{ config, pkgs, ... }:

{
  services.traefik.enable = true;
  services.traefik.staticConfigOptions = {

    log.level = "DEBUG";

    certificatesResolvers.nathilcom.acme = {
      email = "sergiofpteixeira@gmail.com";
      storage = "/var/lib/traefik/acme.json";

      dnsChallenge.provider = "cloudflare";
      dnsChallenge.delayBeforeCheck = 0;
    };

    entryPoints = {
      http = {
        address = ":80";
        forwardedHeaders.insecure = true;
        http.redirections.entryPoint = {
          to = "https";
          scheme = "https";
        };
      };

      https = {
        address = ":443";
        forwardedHeaders.insecure = true;
      };

      experimental = {
        address = ":1111";
        forwardedHeaders.insecure = true;
      };
    };

    api.dashboard = true;
    api.insecure = false;

  };

  age.secrets.cloudflare_token = {
    file = ../secrets/cloudflare_token.age;
  };
  systemd.services.traefik = {
    serviceConfig = {
      EnvironmentFile = [ config.age.secrets.cloudflare_token.path ];
    };
  };
}
