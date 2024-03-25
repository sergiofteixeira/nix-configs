{config, pkgs, ...}:
{
  services.vaultwarden.enable = true;
  services.vaultwarden = {
    backupDir = "/backup/vaultwarden";
    config = {
      domain = "https://vault.sergioteixeira.xyz";
      invitationsAllowed = true;
      rocketPort = 8999;
      signupsAllowed = true;
      websocketEnabled = true;
      loginRatelimitSeconds = 30;
    };
  };
}
