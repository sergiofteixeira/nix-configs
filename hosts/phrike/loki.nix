{
  config,
  pkgs,
  inputs,
  ...
}:

{
  # Configure Loki service
  services.loki = {
    enable = true;
    package = inputs.lloki.packages.${pkgs.system}.loki;
    configuration = {
      auth_enabled = false;
      server = {
        http_listen_port = 3100;
      };
      analytics.reporting_enabled = false;
      storage_config = {
        index_queries_cache_config = {
          redis = {
            endpoint = "localhost:6379";
            expiration = "1h";
          };
        };
      };

      limits_config = {
        reject_old_samples = true;
        reject_old_samples_max_age = "168h";
        retention_period = "360h";
        retention_stream = [
          {
            selector = "{environment=\"dev\"}";
            priority = 1;
            period = "24h";
          }
        ];
        split_queries_by_interval = "24h";
      };

      query_scheduler = {
        max_outstanding_requests_per_tenant = 2048;
      };

      schema_config = {
        configs = [
          {
            from = "2022-05-15";
            store = "boltdb-shipper";
            object_store = "filesystem";
            schema = "v11";
            index = {
              prefix = "index_";
              period = "24h";
            };
          }
        ];
      };
    };
  };
}
