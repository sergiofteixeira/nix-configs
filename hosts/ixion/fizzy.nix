{ pkgs, ... }:

let
  domain = "temporalreach.cloud";
  hostName = "fizzy.${domain}";
  dataDir = "/var/lib/fizzy";
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
      ASSUME_SSL = "true";
      BASE_URL = "https://${hostName}";
      FORCE_SSL = "false";
      MAILER_FROM_ADDRESS = "fizzy@${domain}";
      SOLID_QUEUE_IN_PUMA = "true";
    };
  };

  systemd.services.docker-fizzy = {
    after = [ "fizzy-env.service" ];
    requires = [ "fizzy-env.service" ];
  };
}
