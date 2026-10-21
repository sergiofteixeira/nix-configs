{
  services.grafana = {
    enable = true;
    settings.server.domain = "grafana.thehiss.dev";
    settings.server.root_url = "https://grafana.thehiss.dev";
    settings.server.http_addr = "127.0.0.1";
    settings.security.secret_key = "SW2YcwTIb9zpOOhoPsMm";
  };
}
