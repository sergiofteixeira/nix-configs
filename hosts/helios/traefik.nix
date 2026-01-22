{ config, ... }:
let
  domain = "temporalreach.cloud";
in
{
  services.traefik = {
    enable = true;

    staticConfigOptions = {
      log = {
        level = "INFO";
        format = "common";
      };

      api = {
        dashboard = true;
        insecure = false;
      };

      entryPoints = {
        web = {
          address = ":80";
          http.redirections.entryPoint = {
            to = "websecure";
            scheme = "https";
            permanent = true;
          };
        };
        websecure = {
          address = ":443";
          http.tls = {
            certResolver = "cloudflare";
            domains = [
              {
                main = "*.${domain}";
                sans = [ domain ];
              }
            ];
          };
        };
      };

      certificatesResolvers.cloudflare.acme = {
        email = "sergiofpteixeira@gmail.com";
        storage = "/var/lib/traefik/acme.json";
        dnsChallenge = {
          provider = "cloudflare";
          resolvers = [
            "8.8.8.8:53"
            "1.1.1.1:53"
          ];
          disablePropagationCheck = true;
          delayBeforeCheck = "100s";
        };
      };
    };

    dynamicConfigOptions = {
      http = {
        routers = {
          bazarr = {
            rule = "Host(`bazarr.${domain}`)";
            entryPoints = [ "websecure" ];
            service = "bazarr";
          };

          jellyfin = {
            rule = "Host(`jellyfin.${domain}`) || Host(`${domain}`)";
            entryPoints = [ "websecure" ];
            service = "jellyfin";
          };

          prowlarr = {
            rule = "Host(`prowlar.${domain}`)";
            entryPoints = [ "websecure" ];
            service = "prowlarr";
          };

          radarr = {
            rule = "Host(`radar.${domain}`)";
            entryPoints = [ "websecure" ];
            service = "radarr";
          };

          sonarr = {
            rule = "Host(`sonar.${domain}`)";
            entryPoints = [ "websecure" ];
            service = "sonarr";
          };

          jellyseerr = {
            rule = "Host(`jellyseer.${domain}`)";
            entryPoints = [ "websecure" ];
            service = "jellyseerr";
          };

          qbittorrent = {
            rule = "Host(`qbittorrent.${domain}`)";
            entryPoints = [ "websecure" ];
            service = "qbittorrent";
          };

          grafana = {
            rule = "Host(`grafana.${domain}`)";
            entryPoints = [ "websecure" ];
            service = "grafana";
          };

          prometheus = {
            rule = "Host(`prometheus.${domain}`)";
            entryPoints = [ "websecure" ];
            service = "prometheus";
          };
        };

        services = {
          bazarr.loadBalancer.servers = [
            { url = "http://localhost:${toString config.services.bazarr.listenPort}"; }
          ];

          jellyfin.loadBalancer.servers = [
            { url = "http://localhost:8096"; }
          ];

          prowlarr.loadBalancer.servers = [
            { url = "http://localhost:9696"; }
          ];

          radarr.loadBalancer.servers = [
            { url = "http://localhost:7878"; }
          ];

          sonarr.loadBalancer.servers = [
            { url = "http://localhost:8989"; }
          ];

          jellyseerr.loadBalancer.servers = [
            { url = "http://localhost:5055"; }
          ];

          qbittorrent.loadBalancer.servers = [
            { url = "http://localhost:8080"; }
          ];

          grafana.loadBalancer.servers = [
            { url = "http://localhost:3000"; }
          ];

          prometheus.loadBalancer.servers = [
            { url = "http://localhost:9090"; }
          ];
        };
      };
    };
  };

  systemd.services.traefik.serviceConfig = {
    EnvironmentFile = config.age.secrets.cloudflare_token.path;
  };

  age.secrets.cloudflare_token = {
    file = ../../secrets/cloudflare_token.age;
  };
}
