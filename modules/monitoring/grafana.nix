{ config, pkgs, ... }:

{
  services.grafana = {
    enable = true;
    settings.server.domain = "grafana.nathil.com";
  };
}
