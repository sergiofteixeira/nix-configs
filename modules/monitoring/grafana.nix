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
      allow_sign_up = true;
      # only my Google account (by its stable subject id) gets in, as server admin;
      # any other account maps to no role and is rejected
      role_attribute_path = "sub == '101218471260156695379' && 'GrafanaAdmin' || ''";
      role_attribute_strict = true;
      allow_assign_grafana_admin = true;
      auto_login = true;
    };

    # Google is the only way in: no username/password form or basic auth
    settings.auth.disable_login_form = true;
    settings."auth.basic".enabled = false;
  };
}
