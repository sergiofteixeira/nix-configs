{ config, ... }:

{
  services.prometheus = {
    enable = true;
    exporters = {
      node = {
        openFirewall = true;
        enable = false;
      };
    };

    scrapeConfigs = [
      {
        job_name = "windows";
        static_configs = [
          {
            targets = [
              "10.200.0.100:9182"
            ];
          }
        ];
      }

    ];
  };
}
