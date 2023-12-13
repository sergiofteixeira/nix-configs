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
      rule = "Host(`sonar.sergioteixeira.xyz`)";
      service = "sonarr";

      tls = {
        certResolver = "sergioteixeiraxyz";
        domains = [{ main = "sonarr.sergioteixeira.xyz"; }];
      };
    };

    services.sonarr.loadBalancer.servers = [{ url = "http://localhost:8989"; }];
  };
}
