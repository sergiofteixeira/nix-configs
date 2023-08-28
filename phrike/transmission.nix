{ config, pkgs, ... }:

{
  services.transmission = {
    user = "steixeira";
    group = "wheel";
    enable = true;
    package = pkgs.unstable.transmission_4;
    settings.rpc-authentication-required = false;
    settings.download-queue-enabled = false;
    settings.rpc-bind-address = "0.0.0.0";
    settings.rpc-host-whitelist-enabled = false;
    settings.rpc-whitelist-enabled = false;
    settings.trash-original-torrent-files = true;
    settings.download-dir = "/home/steixeira/external_disk/downloads";
    settings.incomplete-dir = "/home/steixeira/external_disk/downloads/incomplete";
    openFirewall = true;
    downloadDirPermissions = "777";
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
