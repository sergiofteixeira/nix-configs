{ config, pkgs, ... }:

{
  services.traefik.enable = true;
  services.traefik.staticConfigOptions = {

    certificatesResolvers.letsEncrypt.acme = {
      email = "sergiofpteixeira@gmail.com";
      storage = "/var/lib/traefik/acme.json";

      dnsChallenge.provider = "cloudflare";

      # Remove for production.
      caServer = "https://acme-staging-v02.api.letsencrypt.org/directory";
    };

    entryPoints = {
      web = {
        address = ":80";
        http.redirections.entryPoint = {
          to = "websecure";
          scheme = "https";
        };
      };

      websecure.address = ":443";
    };

    api = {
      dashboard = true;
      insecure = true;
    };
  };

  services.traefik.dynamicConfigOptions = {
    http.routers = {
      traefik = {
        entryPoints = [ "websecure" ];
        rule = "Host(`traefik.nathil.com`)";
        service = "api@internal";
      };
    };
  };
}
