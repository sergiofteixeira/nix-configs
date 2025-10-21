{
  config,
  pkgs,
  ...
}:
let
  hostname = "${config.networking.hostName}";
in
{
  services.prometheus.exporters.node = {
    enable = true;
    enabledCollectors = [
      "systemd"
      "processes"
      "os"
    ];
  };

  services.alloy = {
    enable = true;
    configPath =
      let
        configAlloy = pkgs.writeText "config.alloy" ''
          prometheus.scrape "node_static" {
            job_name = "node-static"
            scheme = "http"
            targets = [
              {
                "__address__" = "[::1]:${builtins.toString config.services.prometheus.exporters.node.port}",
                "instance" = "${hostname}",
              },
            ]
            forward_to = [prometheus.remote_write.prometheus.receiver]
            scrape_interval = "30s"
          }
          prometheus.remote_write "prometheus" {
            endpoint {
              url = "https://prometheus.temporalreach.cloud/api/v1/write"
            }
          }
        '';
      in
      pkgs.runCommand "grafana-alloy.d" { } ''
        mkdir $out
        cp "${configAlloy}" "$out/config.alloy"
      '';
  };

}
