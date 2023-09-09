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

    services.codeserver = {
      loadBalancer.servers = [{ url = "http://192.168.1.81:4444"; }];
    };

    services.prometheus = {
      loadBalancer.servers = [{ url = "http://192.168.1.81:9090"; }];
    };

    services.grafana = {
      loadBalancer.servers = [{ url = "http://192.168.1.81:3000"; }];
    };

    routers.unifi = {
      rule = "Host(`unifi.nathil.com`)";
      service = "unifi";
      entryPoints = [ "https" ];
      tls.domains = [{ main = "*.nathil.com"; }];
      tls.certResolver = "nathilcom";
    };

    routers.codeserver = {
      rule = "Host(`codeserver.nathil.com`)";
      service = "codeserver";
      entryPoints = [ "https" ];
      tls.domains = [{ main = "*.nathil.com"; }];
      tls.certResolver = "nathilcom";
    };

    routers.prometheus = {
      rule = "Host(`prometheus.nathil.com`)";
      service = "prometheus";
      entryPoints = [ "https" ];
      tls.domains = [{ main = "*.nathil.com"; }];
      tls.certResolver = "nathilcom";
    };

    routers.grafana = {
      rule = "Host(`grafana.nathil.com`)";
      service = "grafana";
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

  age.secrets.cloudflare_token = {
    file = ../../secrets/cloudflare_token.age;
  };
  systemd.services.traefik = {
    serviceConfig = {
      EnvironmentFile = [ config.age.secrets.cloudflare_token.path ];
    };
  };
}
