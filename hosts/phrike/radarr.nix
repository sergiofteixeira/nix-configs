{ config, pkgs, ... }:

{
  services.radarr = {
    enable = true;
    dataDir = "/opt/radarr";
    user = "steixeira";
    group = "wheel";
    openFirewall = true;
  };

  services.traefik.dynamicConfigOptions.http = {
    routers.radarr = {
      entryPoints = [ "https" ];
      rule = "Host(`radar.sergioteixeira.xyz`)";
      service = "radarr";

      tls = {
        certResolver = "sergioteixeiraxyz";
        domains = [{ main = "*.sergioteixeira.xyz"; }];
      };
    };

    services.radarr.loadBalancer.servers = [{ url = "http://localhost:7878"; }];
  };
}
