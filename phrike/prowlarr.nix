{ config, pkgs, ... }:

{
  services.prowlarr = {
    enable = true;
    openFirewall = true;
  };

  services.traefik.dynamicConfigOptions.http = {
    routers.prowlarr = {
      entryPoints = [ "https" ];
      rule = "Host(`prowlar.nathil.com`)";
      service = "prowlarr";

      tls = {
        certResolver = "nathilcom";
        domains = [{ main = "*.nathil.com"; }];
      };
    };

    services.prowlarr.loadBalancer.servers = [{ url = "http://localhost:9696"; }];
  };
}