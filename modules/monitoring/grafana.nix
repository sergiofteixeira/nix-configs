{ config, pkgs, ... }:

{
  services.grafana = {
    enable = true;
    settings.server.domain = "grafana.nathil.com";
  };

  services.traefik.dynamicConfigOptions.http = {
    routers.grafana = {
      entryPoints = [ "https" ];
      rule = "Host(`grafana.nathil.com`)";
      service = "grafana";

      tls = {
        certResolver = "nathilcom";
        domains = [{ main = "grafana.nathil.com"; }];
      };
    };

    services.grafana.loadBalancer.servers = [{ url = "http://localhost:3000"; }];
  };
}
