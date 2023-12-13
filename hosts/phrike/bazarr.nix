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
      rule = "Host(`bazarr.sergioteixeira.xyz`)";
      service = "bazarr";

      tls = {
        certResolver = "sergioteixeiraxyz";
        domains = [{ main = "*.sergioteixeira.xyz"; }];
      };
    };

    services.bazarr.loadBalancer.servers = [{ url = "http://localhost:6767"; }];
  };
}

