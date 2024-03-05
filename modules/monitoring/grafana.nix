{
  services.grafana = {
    enable = true;
    settings.server.domain = "grafana.sergioteixeira.xyz";
    settings.server.root_url = "https://grafana.sergioteixeira.xyz";
    settings.server.http_addr = "192.168.1.81";
  };
}
