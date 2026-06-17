{ config, pkgs, ... }:

let
  domain = "temporalreach.cloud";
  hostName = "kan.${domain}";
  dataDir = "/var/lib/kan";
  networkName = "kan-network";

  cloudflareDnsSync = pkgs.writeShellApplication {
    name = "cloudflare-dns-sync-kan";
    runtimeInputs = with pkgs; [
      curl
      jq
    ];
    text = ''
      set -euo pipefail

      if [ -f "${config.age.secrets.cloudflare_token.path}" ]; then
        set -a
        # shellcheck disable=SC1091
        . "${config.age.secrets.cloudflare_token.path}"
        set +a
      fi

      token="''${CLOUDFLARE_DNS_API_TOKEN:-''${CF_DNS_API_TOKEN:-''${CLOUDFLARE_API_TOKEN:-}}}"
      if [ -z "$token" ]; then
        echo "Missing Cloudflare token in ${config.age.secrets.cloudflare_token.path}" >&2
        exit 1
      fi

      zone_id=$(curl -fsS \
        -H "Authorization: Bearer $token" \
        -H "Content-Type: application/json" \
        "https://api.cloudflare.com/client/v4/zones?name=${domain}" \
        | jq -r '.result[0].id')

      if [ -z "$zone_id" ] || [ "$zone_id" = "null" ]; then
        echo "Could not find Cloudflare zone ${domain}" >&2
        exit 1
      fi

      public_ip=$(curl -fsS https://api.ipify.org)
      record_id=$(curl -fsS \
        -H "Authorization: Bearer $token" \
        -H "Content-Type: application/json" \
        "https://api.cloudflare.com/client/v4/zones/$zone_id/dns_records?type=A&name=${hostName}" \
        | jq -r '.result[0].id // empty')

      payload=$(jq -n \
        --arg type "A" \
        --arg name "${hostName}" \
        --arg content "$public_ip" \
        '{type: $type, name: $name, content: $content, ttl: 1, proxied: false}')

      if [ -n "$record_id" ]; then
        curl -fsS -X PUT \
          -H "Authorization: Bearer $token" \
          -H "Content-Type: application/json" \
          --data "$payload" \
          "https://api.cloudflare.com/client/v4/zones/$zone_id/dns_records/$record_id" \
          >/dev/null
      else
        curl -fsS -X POST \
          -H "Authorization: Bearer $token" \
          -H "Content-Type: application/json" \
          --data "$payload" \
          "https://api.cloudflare.com/client/v4/zones/$zone_id/dns_records" \
          >/dev/null
      fi
    '';
  };
in
{
  systemd.tmpfiles.rules = [
    "d ${dataDir} 0750 root root - -"
  ];

  systemd.services.kan-env = {
    description = "Create Kan environment files";
    wantedBy = [ "multi-user.target" ];
    before = [
      "docker-kan-postgres.service"
      "kan-migrate.service"
      "docker-kan.service"
    ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      UMask = "0077";
    };
    path = with pkgs; [
      coreutils
      gnugrep
      openssl
    ];
    script = ''
      install -d -m 0750 ${dataDir}
      if [ ! -f ${dataDir}/kan.env ]; then
        postgres_password=$(openssl rand -hex 32)
        auth_secret=$(openssl rand -hex 32)
        admin_api_key=$(openssl rand -hex 32)
        {
          printf 'POSTGRES_PASSWORD=%s\n' "$postgres_password"
          printf 'POSTGRES_URL=postgres://kan:%s@kan-postgres:5432/kan_db\n' "$postgres_password"
          printf 'BETTER_AUTH_SECRET=%s\n' "$auth_secret"
          printf 'KAN_ADMIN_API_KEY=%s\n' "$admin_api_key"
        } > ${dataDir}/kan.env
      fi

      grep '^POSTGRES_PASSWORD=' ${dataDir}/kan.env > ${dataDir}/postgres.env
    '';
  };

  systemd.services.kan-network = {
    description = "Create Kan Docker network";
    wantedBy = [ "multi-user.target" ];
    after = [ "docker.service" ];
    requires = [ "docker.service" ];
    before = [
      "docker-kan-postgres.service"
      "kan-migrate.service"
      "docker-kan.service"
    ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    path = with pkgs; [
      coreutils
      config.virtualisation.docker.package
    ];
    script = ''
      docker network inspect ${networkName} >/dev/null 2>&1 || docker network create ${networkName}
    '';
  };

  virtualisation.oci-containers.containers = {
    kan-postgres = {
      image = "postgres:15";
      autoStart = true;
      extraOptions = [
        "--network=${networkName}"
        "--network-alias=kan-postgres"
      ];
      volumes = [ "kan_postgres_data:/var/lib/postgresql/data" ];
      environmentFiles = [ "${dataDir}/postgres.env" ];
      environment = {
        POSTGRES_DB = "kan_db";
        POSTGRES_USER = "kan";
      };
    };

    kan = {
      image = "ghcr.io/kanbn/kan:latest";
      autoStart = true;
      ports = [ "127.0.0.1:3003:3000" ];
      extraOptions = [ "--network=${networkName}" ];
      environmentFiles = [ "${dataDir}/kan.env" ];
      environment = {
        NEXT_PUBLIC_BASE_URL = "https://${hostName}";
        BETTER_AUTH_TRUSTED_ORIGINS = "https://${hostName}";
        NEXT_PUBLIC_ALLOW_CREDENTIALS = "true";
        NEXT_PUBLIC_DISABLE_EMAIL = "true";
        NEXT_PUBLIC_WHITE_LABEL_HIDE_POWERED_BY = "true";
        LOG_LEVEL = "info";
      };
    };
  };

  systemd.services.docker-kan-postgres = {
    after = [
      "kan-env.service"
      "kan-network.service"
    ];
    requires = [
      "kan-env.service"
      "kan-network.service"
    ];
  };

  systemd.services.kan-migrate = {
    description = "Run Kan database migrations";
    wantedBy = [ "multi-user.target" ];
    after = [
      "docker-kan-postgres.service"
      "kan-env.service"
      "kan-network.service"
    ];
    requires = [
      "docker-kan-postgres.service"
      "kan-env.service"
      "kan-network.service"
    ];
    before = [ "docker-kan.service" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    path = with pkgs; [
      coreutils
      config.virtualisation.docker.package
    ];
    script = ''
      for attempt in $(seq 1 60); do
        if docker exec kan-postgres pg_isready -U kan -d kan_db >/dev/null 2>&1; then
          break
        fi

        if [ "$attempt" -eq 60 ]; then
          echo "Kan Postgres did not become ready" >&2
          exit 1
        fi

        sleep 2
      done

      docker run --rm \
        --network ${networkName} \
        --env-file ${dataDir}/kan.env \
        ghcr.io/kanbn/kan-migrate:latest
    '';
  };

  systemd.services.docker-kan = {
    after = [ "kan-migrate.service" ];
    requires = [ "kan-migrate.service" ];
  };

  systemd.services.cloudflare-dns-kan = {
    description = "Create or update Cloudflare DNS record for Kan";
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${cloudflareDnsSync}/bin/cloudflare-dns-sync-kan";
    };
  };

  systemd.timers.cloudflare-dns-kan = {
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnBootSec = "2min";
      OnUnitActiveSec = "1h";
      Unit = "cloudflare-dns-kan.service";
    };
  };
}
