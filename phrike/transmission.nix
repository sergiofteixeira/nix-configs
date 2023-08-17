{ config, pkgs, ... }:

{
  services.transmission = {
    enable = true;
    settings.rpc-authentication-required = false;
    settings.download-queue-enabled = false;
    settings.rpc-bind-address = "0.0.0.0";

    settings.trash-original-torrent-files = true;
    settings.download-dir = "/home/steixeira/external_disk/downloads";
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

    services.transmission.loadBalancer.servers =
      [{ url = "http://localhost:9091"; }];
  };
}
