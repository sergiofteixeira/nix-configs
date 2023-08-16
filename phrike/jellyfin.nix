{ config, pkgs, ... }:

{
  services.jellyfin = {
    user = "steixeira";
    enable = true;
    openFirewall = true;
  };

    services.traefik.dynamicConfigOptions.http = {
    routers.jellyfin = {
      entryPoints = [ "https" ];
      rule = "Host(`jellyfin.nathil.com`)";
      service = "jellyfin";

      tls = {
        certResolver = "nathilcom";
        domains = [{ main = "*.nathil.com"; }];
      };
    };

    services.jellyfin.loadBalancer.servers = [{ url = "http://localhost:8096"; }];
  };
}
