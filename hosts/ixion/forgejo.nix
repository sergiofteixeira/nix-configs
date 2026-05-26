{ ... }:

{
  services.postgresql.enable = true;

  services.forgejo = {
    enable = true;
    database.type = "postgres";

    settings = {
      server = {
        DOMAIN = "code.temporalreach.cloud";
        ROOT_URL = "https://code.temporalreach.cloud/";
        HTTP_ADDR = "127.0.0.1";
        HTTP_PORT = 3001;
        START_SSH_SERVER = true;
        SSH_PORT = 2222;
      };

      service.DISABLE_REGISTRATION = true;

      ui.THEMES = "forgejo-auto,forgejo-light,forgejo-dark,gitea-auto,gitea-light,gitea-dark,anthracite,anthracite-light,anthracite-dark";
    };
  };

  systemd.tmpfiles.rules = [
    "d /var/lib/forgejo/custom/public 0755 forgejo forgejo - -"
    "d /var/lib/forgejo/custom/public/assets 0755 forgejo forgejo - -"
    "d /var/lib/forgejo/custom/public/assets/css 0755 forgejo forgejo - -"
    "L+ /var/lib/forgejo/custom/public/assets/css/theme-anthracite.css - - - - ${./forgejo-themes/theme-anthracite.css}"
    "L+ /var/lib/forgejo/custom/public/assets/css/theme-anthracite-dark.css - - - - ${./forgejo-themes/theme-anthracite-dark.css}"
    "L+ /var/lib/forgejo/custom/public/assets/css/theme-anthracite-light.css - - - - ${./forgejo-themes/theme-anthracite-light.css}"
  ];
}
