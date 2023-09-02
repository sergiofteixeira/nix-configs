{ config, pkgs, ... }:

{
  services.prometheus = {
    enable = true;
    exporters = {
      node = {
        openFirewall = true;
        enable = true;
        enabledCollectors = [ "systemd" ];
      };
    };

    scrapeConfigs = [
      {
        job_name = "phrike";
        static_configs = [{
          targets = [
            "192.168.1.80:${
              toString config.services.prometheus.exporters.node.port
            }"
          ];
        }];
      }
      {
        job_name = "helios";
        static_configs = [{
          targets = [
            "192.168.1.81:${
              toString config.services.prometheus.exporters.node.port
            }"
          ];
        }];
      }

    ];
  };
}
