{ ... }:
{
  services.vaultwarden.enable = true;
  services.vaultwarden = {
    config = {
      domain = "https://vault.sergioteixeira.xyz";
      invitationsAllowed = false;
      signupsAllowed = true;
      websocketEnabled = true;
      loginRatelimitSeconds = 30;
    };
  };
}
