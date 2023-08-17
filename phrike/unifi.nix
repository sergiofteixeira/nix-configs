{ config, pkgs, ... }:

{
  services.unifi = {
    enable = true;
    openFirewall = true;
    mongodbPackage = pkgs.mongodb-4_2;
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

    services.jellyfin.loadBalancer.servers =
      [{ url = "http://localhost:8880"; }];
  };
}
