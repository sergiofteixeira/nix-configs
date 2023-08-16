{ config, pkgs, ... }:

{
  services.transmission = {
    enable = true;
    settings.rpc-authentication-required = false;
    settings.download-queue-enabled = false;
    openFirewall = true;
  };

  services.traefik.dynamicConfigOptions.http = {
    routers.transmission = {
      entryPoints = [ "https" ];
      rule = "Host(`downloader.nathil.com`)";
      service = "transmission";

      tls = {
        certResolver = "nathilcom";
        domains = [{ main = "*.nathil.com"; }];
      };
    };

    services.transmission.loadBalancer.servers = [{ url = "http://localhost:9091"; }];
  };
}