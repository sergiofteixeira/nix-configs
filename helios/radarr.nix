{ config, pkgs, ... }:

{
  services.radarr = {
    enable = true;
    dataDir = "/opt/radarr";
    user = "steixeira";
    openFirewall = true;
  };

  services.traefik.dynamicConfigOptions.http = {
    routers.radarr = {
      entryPoints = [ "https" ];
      rule = "Host(`radarr.nathil.com`)";
      service = "radarr";

      tls = {
        certResolver = "nathilcom";
        domains = [{ main = "radarr.nathil.com"; }];
      };
    };

    services.radarr.loadBalancer.servers = [{ url = "http://localhost:7878"; }];
  };
}
