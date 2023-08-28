{ config, pkgs, ... }:

{
  services.sonarr = {
    enable = true;
    dataDir = "/opt/sonarr";
    user = "steixeira";
    group = "wheel";
    openFirewall = true;
  };

  services.traefik.dynamicConfigOptions.http = {
    routers.sonarr = {
      entryPoints = [ "https" ];
      rule = "Host(`sonar.nathil.com`)";
      service = "sonarr";

      tls = {
        certResolver = "nathilcom";
        domains = [{ main = "sonarr.nathil.com"; }];
      };
    };

    services.sonarr.loadBalancer.servers = [{ url = "http://localhost:8989"; }];
  };
}