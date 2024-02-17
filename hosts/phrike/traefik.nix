{ config, pkgs, ... }:

{
  services.traefik.enable = true;
  services.traefik.staticConfigOptions = {

    serversTransport.insecureSkipVerify = true;

    log.level = "INFO";

    certificatesResolvers.sergioteixeiraxyz.acme = {
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

    #services.prometheus = {
      #loadBalancer.servers = [{ url = "http://192.168.1.81:9090"; }];
    #};

    #services.grafana = {
      #loadBalancer.servers = [{ url = "http://192.168.1.81:3000"; }];
    #};

    #services.nomad = {
      #loadBalancer.servers = [{ url = "http://192.168.1.81:4646"; }];
    #};

    routers.unifi = {
      rule = "Host(`unifi.sergioteixeira.xyz`)";
      service = "unifi";
      entryPoints = [ "https" ];
      tls.domains = [{ main = "*.sergioteixeira.xyz"; }];
      tls.certResolver = "sergioteixeiraxyz";
    };

    #routers.nomad = {
      #rule = "Host(`nomad.sergioteixeira.xyz`)";
      #service = "nomad";
      #entryPoints = [ "https" ];
      #tls.domains = [{ main = "*.sergioteixeira.xyz"; }];
      #tls.certResolver = "sergioteixeiraxyz";
    #};

    #routers.prometheus = {
      #rule = "Host(`prometheus.sergioteixeira.xyz`)";
      #service = "prometheus";
      #entryPoints = [ "https" ];
      #tls.domains = [{ main = "*.sergioteixeira.xyz"; }];
      #tls.certResolver = "sergioteixeiraxyz";
    #};

    #routers.grafana = {
      #rule = "Host(`grafana.sergioteixeira.xyz`)";
      #service = "grafana";
      #entryPoints = [ "https" ];
      #tls.domains = [{ main = "*.sergioteixeira.xyz"; }];
      #tls.certResolver = "sergioteixeiraxyz";
    #};

    routers.dashboard = {
      rule = "Host(`traefik.sergioteixeira.xyz`)";
      service = "api@internal";
      entryPoints = [ "https" ];
      tls.domains = [{ main = "*.sergioteixeira.xyz"; }];
      tls.certResolver = "sergioteixeiraxyz";
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
