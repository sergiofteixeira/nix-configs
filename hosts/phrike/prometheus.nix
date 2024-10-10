{ config, ... }:
let
  environments = [
    "dev"
    "prod"
    "staging"
  ];

  generateRulesForEnv = env: {
    name = "monitoring-machine";
    rules = [
      {
        alert = "File System Almost Full";
        annotations.description = "{{$labels.instance}} device {{$labels.device}} on {{$labels.path}} got less than 10% space left on its filesystem";
        for = "5m";
        expr = ''100 - ((node_filesystem_avail_bytes{fstype="ext4",mountpoint="/"} * 100) / node_filesystem_size_bytes{fstype="ext4",mountpoint="/"}) >= 90'';
        labels = {
          severity = "warning";
          channel = "alerts-${env}";
        };
      }
    ];
  };

  recordingRules = {
    name = "recording-rules";
    rules = [
      {
        record = "slo:production:30d";
        expr = "avg(avg_over_time(probe_success{environment=\"prod\", instance=~\"tiko.*\"}[30d]) * 100)";
      }
    ];
  };

in
{
  services.prometheus = {
    enable = true;
    extraFlags = [
      "--web.enable-remote-write-receiver"
      "--storage.tsdb.retention.time=60d"
    ];

    exporters = {
      node = {
        enable = true;
        enabledCollectors = [ "systemd" ];
      };
    };
    scrapeConfigs = [
      {
        job_name = "monitoring";
        static_configs = [
          { targets = [ "127.0.0.1:${toString config.services.prometheus.exporters.node.port}" ]; }
        ];
      }
    ];

    rules = [
      (builtins.toJSON {
        groups = [
          recordingRules
        ] ++ generateRulesForEnv environments;
      })
    ];
  };
}
