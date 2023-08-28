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
      rule = "Host(`radar.nathil.com`)";
      service = "radarr";

      tls = {
        certResolver = "nathilcom";
        domains = [{ main = "*.nathil.com"; }];
      };
    };

    services.radarr.loadBalancer.servers = [{ url = "http://localhost:7878"; }];
  };
}
