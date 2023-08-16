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
      rule = "Host(`plex.nathil.com`)";
      service = "plex";

      tls = {
        certResolver = "nathilcom";
        domains = [{ main = "*.nathil.com"; }];
      };
    };

    services.plex.loadBalancer.servers = [{ url = "http://localhost:32400"; }];
  };
}