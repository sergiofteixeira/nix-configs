{
  config,
  pkgs,
  ...
}:
{

  services.alloy = {
    enable = true;
    configPath =
      let
        configAlloy = pkgs.writeText "config.alloy" ''
          prometheus.exporter.unix "default" {
            include_exporter_metrics = true
            disable_collectors       = ["mdadm"]
          }
          prometheus.scrape "default" {
            scheme = "http"
            targets = array.concat(
              prometheus.exporter.unix.default.targets,
              [{
                // Self-collect metrics
                "job"         = "alloy",
                "__address__" = "127.0.0.1:12345",
              }],
            )
            forward_to = [prometheus.remote_write.default.receiver]
            scrape_interval = "30s"
          }
          prometheus.remote_write "default" {
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
