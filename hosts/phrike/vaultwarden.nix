{ ... }:

{
  services.vaultwarden = {
    enable = true;
    backupDir = "/backup-disk/vaultwarden";
    config = {
      DOMAIN = "https://vaultwarden.temporalreach.cloud";
      SIGNUPS_ALLOWED = true;
      SHOW_PASSWORD_HINT = true;
      ROCKET_ADDRESS = "127.0.0.1";
      ROCKET_PORT = 8222;
      ROCKET_LOG = "critical";
      SMTP_HOST = "localhost";
      SMTP_PORT = 25;
      SMTP_SSL = false;
      SMTP_FROM = "vaultwarden@temporalreach.cloud";
      SMTP_FROM_NAME = "NixOS Vaultwarden";
      ORG_EVENTS_ENABLED = true;
    };
  };
}
