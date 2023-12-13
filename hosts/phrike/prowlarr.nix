{ config, pkgs, ... }:

{
  services.prowlarr = {
    enable = true;
    openFirewall = true;
  };

  services.traefik.dynamicConfigOptions.http = {
    routers.prowlarr = {
      entryPoints = [ "https" ];
      rule = "Host(`prowlar.sergioteixeira.xyz`)";
      service = "prowlarr";

      tls = {
        certResolver = "sergioteixeiraxyz";
        domains = [{ main = "*.sergioteixeira.xyz"; }];
      };
    };

    services.prowlarr.loadBalancer.servers = [{ url = "http://localhost:9696"; }];
  };
}
