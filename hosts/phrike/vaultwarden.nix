{config, pkgs, ...}:
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

  services.traefik.dynamicConfigOptions.http = {
    routers.vaultwarden = {
      entryPoints = [ "https" ];
      rule = "Host(`vault.sergioteixeira.xyz`)";
      service = "vaultwarden";

      tls = {
        certResolver = "sergioteixeiraxyz";
        domains = [{ main = "*.sergioteixeira.xyz"; }];
      };
    };

    services.vaultwarden.loadBalancer.servers = [{ url = "http://localhost:8000"; }];
    };
}
