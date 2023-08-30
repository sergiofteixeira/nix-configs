{ config, pkgs, ... }:

{
  services.prowlarr = {
    enable = true;
    openFirewall = true;
  };

  services.traefik.dynamicConfigOptions.http = {
    routers.unifi = {
      entryPoints = [ "https" ];
      rule = "Host(`unifi.nathil.com`)";
      service = "unifi";

      tls = {
        certResolver = "nathilcom";
        domains = [{ main = "*.nathil.com"; }];
      };
    };
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
    services.unifi.loadBalancer.servers = [{ url = "https://localhost:8443"; }];
  };
}
