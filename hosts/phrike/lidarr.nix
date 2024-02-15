{ config, pkgs, ... }:

{
  services.lidarr = {
    enable = true;
    openFirewall = true;
    group = "wheel";
    user = "steixeira";
  };

  services.traefik.dynamicConfigOptions.http = {
    routers.lidarr = {
      entryPoints = [ "https" ];
      rule = "Host(`lidarr.sergioteixeira.xyz`)";
      service = "lidarr";

      tls = {
        certResolver = "sergioteixeiraxyz";
        domains = [{ main = "*.sergioteixeira.xyz"; }];
      };
    };

    services.lidarr.loadBalancer.servers = [{ url = "http://localhost:8686"; }];
  };
}


