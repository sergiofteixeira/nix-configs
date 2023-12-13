{ config, pkgs, ... }:

{
  services.jellyfin = {
    user = "steixeira";
    enable = true;
    openFirewall = true;
  };

  services.traefik.dynamicConfigOptions.http = {
    routers.jellyfin = {
      entryPoints = [ "https" ];
      rule = "Host(`jellyfin.sergioteixeira.xyz`)";
      service = "jellyfin";

      tls = {
        certResolver = "sergioteixeiraxyz";
        domains = [{ main = "*.sergioteixeira.xyz"; }];
      };
    };

    services.jellyfin.loadBalancer.servers =
      [{ url = "http://localhost:8096"; }];
  };
}
