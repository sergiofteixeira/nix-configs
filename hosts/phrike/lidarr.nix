{ config, pkgs, ... }:

{
  services.lidarr = {
    enable = true;
    openFirewall = true;
    group = "wheel";
    user = "steixeira";
  };

  services.traefik.dynamicConfigOptions.http = {
    routers.lidar = {
      entryPoints = [ "https" ];
      rule = "Host(`lidarr.sergioteixeira.xyz`)";
      service = "lidarrr";

      tls = {
        certResolver = "sergioteixeiraxyz";
        domains = [{ main = "*.sergioteixeira.xyz"; }];
      };
    };

    services.bazarr.loadBalancer.servers = [{ url = "http://localhost:8686"; }];
  };
}


