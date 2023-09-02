{ config, pkgs, ... }:

{
  services.bazarr = {
    enable = true;
    openFirewall = true;
    group = "wheel";
    user = "steixeira";
  };

  services.traefik.dynamicConfigOptions.http = {
    routers.bazarr = {
      entryPoints = [ "https" ];
      rule = "Host(`bazarr.nathil.com`)";
      service = "bazarr";

      tls = {
        certResolver = "nathilcom";
        domains = [{ main = "*.nathil.com"; }];
      };
    };

    services.bazarr.loadBalancer.servers = [{ url = "http://localhost:6767"; }];
  };
}

