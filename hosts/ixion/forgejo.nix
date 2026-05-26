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
    };
  };
}
