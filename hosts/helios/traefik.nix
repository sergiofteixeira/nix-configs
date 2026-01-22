{ config, ... }:
let
  domain = "temporalreach.cloud";
in
{
  # Traefik replaces both nginx and acme
  services.traefik = {
    enable = true;

    # Static configuration
    staticConfigOptions = {
      # Logging
      log = {
        level = "INFO";
        format = "common";
      };

      # API and Dashboard
      api = {
        dashboard = true;
        insecure = false; # Dashboard will be secured via router
      };

      # Entry points (ports)
      entryPoints = {
        web = {
          address = ":80";
          # Redirect HTTP to HTTPS
          http.redirections.entryPoint = {
            to = "websecure";
            scheme = "https";
            permanent = true;
          };
        };
        websecure = {
          address = ":443";
        };
      };

      # Certificate resolver using Cloudflare DNS challenge
      certificatesResolvers.cloudflare.acme = {
        email = "sergiofpteixeira@gmail.com";
        storage = "/var/lib/traefik/acme.json";
        dnsChallenge = {
          provider = "cloudflare";
          resolvers = [
            "1.1.1.1:53"
            "8.8.8.8:53"
          ];
          delayBeforeCheck = "0s";
        };
      };
    };

    # Dynamic configuration (routers and services)
    dynamicConfigOptions = {
      http = {
        # Routers
        routers = {
          # Bazarr
          bazarr = {
            rule = "Host(`bazarr.${domain}`)";
            entryPoints = [ "websecure" ];
            service = "bazarr";
            tls.domains = [
              {
                main = "*.${domain}";
                sans = [ domain ];
              }
            ];
            tls.certResolver = "cloudflare";
          };

          # Jellyfin
          jellyfin = {
            rule = "Host(`jellyfin.${domain}`)";
            entryPoints = [ "websecure" ];
            service = "jellyfin";
            tls.domains = [
              {
                main = "*.${domain}";
                sans = [ domain ];
              }
            ];
            tls.certResolver = "cloudflare";
          };

          # Prowlarr
          prowlarr = {
            rule = "Host(`prowlar.${domain}`)";
            entryPoints = [ "websecure" ];
            service = "prowlarr";
            tls.domains = [
              {
                main = "*.${domain}";
                sans = [ domain ];
              }
            ];
            tls.certResolver = "cloudflare";
          };

          # Radarr
          radarr = {
            rule = "Host(`radar.${domain}`)";
            entryPoints = [ "websecure" ];
            service = "radarr";
            tls.domains = [
              {
                main = "*.${domain}";
                sans = [ domain ];
              }
            ];
            tls.certResolver = "cloudflare";
          };

          # Sonarr
          sonarr = {
            rule = "Host(`sonar.${domain}`)";
            entryPoints = [ "websecure" ];
            service = "sonarr";
            tls.domains = [
              {
                main = "*.${domain}";
                sans = [ domain ];
              }
            ];
            tls.certResolver = "cloudflare";
          };

          # Jellyseerr
          jellyseerr = {
            rule = "Host(`jellyseer.${domain}`)";
            entryPoints = [ "websecure" ];
            service = "jellyseerr";
            tls.domains = [
              {
                main = "*.${domain}";
                sans = [ domain ];
              }
            ];
            tls.certResolver = "cloudflare";
          };

          # qBittorrent
          qbittorrent = {
            rule = "Host(`qbittorrent.${domain}`)";
            entryPoints = [ "websecure" ];
            service = "qbittorrent";
            tls.domains = [
              {
                main = "*.${domain}";
                sans = [ domain ];
              }
            ];
            tls.certResolver = "cloudflare";
          };

          # Grafana
          grafana = {
            rule = "Host(`grafana.${domain}`)";
            entryPoints = [ "websecure" ];
            service = "grafana";
            tls.domains = [
              {
                main = "*.${domain}";
                sans = [ domain ];
              }
            ];
            tls.certResolver = "cloudflare";
          };

          # Prometheus
          prometheus = {
            rule = "Host(`prometheus.${domain}`)";
            entryPoints = [ "websecure" ];
            service = "prometheus";
            tls.domains = [
              {
                main = "*.${domain}";
                sans = [ domain ];
              }
            ];
            tls.certResolver = "cloudflare";
          };
        };

        # Services (backends)
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

  # Traefik needs the Cloudflare credentials
  systemd.services.traefik.serviceConfig = {
    EnvironmentFile = config.age.secrets.cloudflare_token.path;
  };

  # Keep the age secret for Cloudflare token
  age.secrets.cloudflare_token = {
    file = ../../secrets/cloudflare_token.age;
  };
}
