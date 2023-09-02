{
  services.grafana = {
    enable = true;
    settings.server.domain = "grafana.nathil.com";
    settings.server.root_url= "https://grafana.nathil.com";
    settings.server.http_addr = "192.168.1.81";
  };
}
