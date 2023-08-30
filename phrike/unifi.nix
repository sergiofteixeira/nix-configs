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

    services.unifi.loadBalancer.servers =
      [{ url = "http://localhost:8443"; }];
  };
}
