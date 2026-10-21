{ config, ... }:
{
  # GF_AUTH_GOOGLE_CLIENT_ID=... and GF_AUTH_GOOGLE_CLIENT_SECRET=...
  age.secrets.grafana_google_oauth = {
    file = ../../secrets/grafana_google_oauth.age;
    owner = "grafana";
  };

  systemd.services.grafana.serviceConfig.EnvironmentFile = config.age.secrets.grafana_google_oauth.path;

  services.grafana = {
    enable = true;
    settings.server.domain = "grafana.thehiss.dev";
    settings.server.root_url = "https://grafana.thehiss.dev";
    settings.server.http_addr = "127.0.0.1";
    settings.security.secret_key = "SW2YcwTIb9zpOOhoPsMm";

    settings."auth.google" = {
      enabled = true;
      scopes = "openid email profile";
      # only users that already exist in Grafana can sign in, matched by email
      allow_sign_up = true;
      auto_login = false;
    };
    settings.auth.oauth_allow_insecure_email_lookup = true;
  };
}
