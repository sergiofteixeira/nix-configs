{ config, pkgs, ... }:

let
  domain = "temporalreach.cloud";
  hostName = "fizzy.${domain}";
  dataDir = "/var/lib/fizzy";

  cloudflareDnsSync = pkgs.writeShellApplication {
    name = "cloudflare-dns-sync-fizzy";
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

  systemd.services.fizzy-env = {
    description = "Create Fizzy environment file";
    wantedBy = [ "multi-user.target" ];
    before = [ "docker-fizzy.service" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      UMask = "0077";
    };
    path = with pkgs; [
      coreutils
      openssl
    ];
    script = ''
      install -d -m 0750 ${dataDir}
      if [ ! -f ${dataDir}/fizzy.env ]; then
        secret_key_base=$(openssl rand -hex 64)
        printf 'SECRET_KEY_BASE=%s\n' "$secret_key_base" > ${dataDir}/fizzy.env
      fi
    '';
  };

  virtualisation.oci-containers.containers.fizzy = {
    image = "ghcr.io/basecamp/fizzy:main";
    autoStart = true;
    ports = [ "127.0.0.1:3002:80" ];
    volumes = [ "fizzy:/rails/storage" ];
    environmentFiles = [ "${dataDir}/fizzy.env" ];
    environment = {
      BASE_URL = "https://${hostName}";
      DISABLE_SSL = "true";
      MAILER_FROM_ADDRESS = "fizzy@${domain}";
    };
  };

  systemd.services.docker-fizzy = {
    after = [ "fizzy-env.service" ];
    requires = [ "fizzy-env.service" ];
  };

  systemd.services.cloudflare-dns-fizzy = {
    description = "Create or update Cloudflare DNS record for Fizzy";
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${cloudflareDnsSync}/bin/cloudflare-dns-sync-fizzy";
    };
  };

  systemd.timers.cloudflare-dns-fizzy = {
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnBootSec = "2min";
      OnUnitActiveSec = "1h";
      Unit = "cloudflare-dns-fizzy.service";
    };
  };
}
