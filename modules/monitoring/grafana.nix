{
  services.grafana = {
    enable = true;
    settings.server.domain = "grafana.temporalreach.cloud";
    settings.server.root_url = "https://grafana.temporalreach.cloud";
    settings.server.http_addr = "127.0.0.1";
  };
}
