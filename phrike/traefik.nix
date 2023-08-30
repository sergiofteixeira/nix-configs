{ config, pkgs, ... }:

{
  services.traefik.enable = true;
  services.traefik.staticConfigOptions = {

    serversTransport.insecureSkipVerify = true;

    log.level = "INFO";

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

  services.traefik.dynamicConfigOptions.http = {
    services.unifi = {
      loadBalancer.servers = [{ url = "https://localhost:8443"; }];
    };

    routers.unifi = {
      rule = "Host(`unifi.nathil.com`)";
      service = "unifi";
      entryPoints = [ "https" ];
      tls.domains = [{ main = "*.nathil.com"; }];
      tls.certResolver = "nathilcom";
    };

    routers.dashboard = {
      rule = "Host(`traefik.nathil.com`)";
      service = "api@internal";
      entryPoints = [ "https" ];
      tls.domains = [{ main = "*.nathil.com"; }];
      tls.certResolver = "nathilcom";
    };
  };

  systemd.services.traefik.environment = {
    CLOUDFLARE_DNS_API_TOKEN = "-6ccCVxiv98iECewr5Cbn6Mfga_6B4g357dWKuA-";
    CLOUDFLARE_EMAIL = "sergiofpteixeira@gmail.com";
  };
}
