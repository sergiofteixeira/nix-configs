{ config, ... }:
let
  port = 28981;
  uid = config.ids.uids.paperless;
  gid = config.ids.gids.paperless;
  redisPort = 6379;
in
{
  # The container runs as this uid, so postgres peer auth over the socket maps
  # it back to the paperless role and the existing files keep their owner.
  users.users.paperless = {
    inherit uid;
    group = "paperless";
    isSystemUser = true;
    home = "/var/lib/paperless";
  };
  users.groups.paperless.gid = gid;

  services.postgresql = {
    enable = true;
    settings.port = 5433;
    ensureDatabases = [ "paperless" ];
    ensureUsers = [
      {
        name = "paperless";
        ensureDBOwnership = true;
      }
    ];
  };

  services.redis.servers.paperless = {
    enable = true;
    bind = "127.0.0.1";
    port = redisPort;
  };

  virtualisation.oci-containers.containers.paperless = {
    image = "ghcr.io/paperless-ngx/paperless-ngx:latest";
    pull = "always";
    extraOptions = [ "--network=host" ];
    environmentFiles = [ "/var/lib/paperless/nixos-paperless-secret-key.env" ];
    environment = {
      USERMAP_UID = toString uid;
      USERMAP_GID = toString gid;
      PAPERLESS_BIND_ADDR = "127.0.0.1";
      PAPERLESS_PORT = toString port;
      PAPERLESS_URL = "https://paperless.thehiss.dev";
      PAPERLESS_REDIS = "redis://127.0.0.1:${toString redisPort}";
      PAPERLESS_DBHOST = "/run/postgresql";
      PAPERLESS_DBPORT = "5433";
      PAPERLESS_DBNAME = "paperless";
      PAPERLESS_DBUSER = "paperless";
      PAPERLESS_OCR_LANGUAGE = "por+eng";
      PAPERLESS_OCR_LANGUAGES = "por";
      PAPERLESS_TIME_ZONE = config.time.timeZone;
      PAPERLESS_FILENAME_FORMAT = "{{ created_year }}/{{ correspondent }}/{{ title }}";
      PAPERLESS_CONSUMER_IGNORE_PATTERN = builtins.toJSON [
        ".DS_Store"
        ".DS_STORE/*"
        "desktop.ini"
        "@eaDir/*"
      ];
    };
    volumes = [
      "/var/lib/paperless:/usr/src/paperless/data"
      "/var/lib/paperless/media:/usr/src/paperless/media"
      "/var/lib/paperless/consume:/usr/src/paperless/consume"
      "/run/postgresql:/run/postgresql"
    ];
  };

  systemd.services.docker-paperless = {
    after = [
      "postgresql.service"
      "redis-paperless.service"
    ];
    requires = [
      "postgresql.service"
      "redis-paperless.service"
    ];
  };
}
