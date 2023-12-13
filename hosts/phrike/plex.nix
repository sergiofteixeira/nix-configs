{ config, pkgs, ... }: {
  services.plex = {
    dataDir = "/home/steixeira/plex";
    user = "steixeira";
    enable = true;
    openFirewall = true;
  };

  services.traefik.dynamicConfigOptions.http = {
    routers.plex = {
      entryPoints = [ "https" ];
      rule = "Host(`plex.sergioteixeira.xyz`)";
      service = "plex";

      tls = {
        certResolver = "sergioteixeiraxyz";
        domains = [{ main = "*.sergioteixeira.xyz"; }];
      };
    };

    services.plex.loadBalancer.servers = [{ url = "http://localhost:32400"; }];
  };
}
