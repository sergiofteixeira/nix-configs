{ config, ... }:
let
  acmeHost = "temporalreach.cloud";
in
{
  services.nginx = {
    enable = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;
    recommendedGzipSettings = true;
    recommendedOptimisation = true;

    virtualHosts = {
      "pihole.temporalreach.cloud" = {
        useACMEHost = acmeHost;
        forceSSL = true;
        locations."/" = {
          proxyPass = "http://localhost:8053";
          proxyWebsockets = true;
        };
      };
      "beszel.temporalreach.cloud" = {
        useACMEHost = acmeHost;
        forceSSL = true;
        locations."/" = {
          proxyPass = "http://localhost:8090";
          proxyWebsockets = true;
        };
      };
      "bazarr.temporalreach.cloud" = {
        useACMEHost = acmeHost;
        forceSSL = true;
        locations."/" = {
          proxyPass = "http://localhost:${toString config.services.bazarr.listenPort}";
          proxyWebsockets = true;
        };
      };
      "jellyfin.temporalreach.cloud" = {
        useACMEHost = acmeHost;
        forceSSL = true;
        locations."/" = {
          proxyPass = "http://localhost:8096";
          proxyWebsockets = true;
        };
      };
      "prowlar.temporalreach.cloud" = {
        useACMEHost = acmeHost;
        forceSSL = true;
        locations."/" = {
          proxyPass = "http://localhost:9696";
          proxyWebsockets = true;
        };
      };
      "radar.temporalreach.cloud" = {
        useACMEHost = acmeHost;
        forceSSL = true;
        locations."/" = {
          proxyPass = "http://localhost:7878";
          proxyWebsockets = true;
        };
      };
      "sonar.temporalreach.cloud" = {
        useACMEHost = acmeHost;
        forceSSL = true;
        locations."/" = {
          proxyPass = "http://localhost:8989";
          proxyWebsockets = true;
        };
      };
      "deluge.temporalreach.cloud" = {
        useACMEHost = acmeHost;
        forceSSL = true;
        locations."/" = {
          proxyPass = "http://localhost:8112";
        };
      };
      "jellyseer.temporalreach.cloud" = {
        useACMEHost = acmeHost;
        forceSSL = true;
        locations."/" = {
          proxyPass = "http://localhost:5055";
        };
      };
      "immich.temporalreach.cloud" = {
        useACMEHost = acmeHost;
        forceSSL = true;
        locations."/" = {
          proxyPass = " http://${config.services.immich.host}:${toString config.services.immich.port}";
          proxyWebsockets = true;
        };
        extraConfig = ''
          # Allow large file uploads
          client_max_body_size 50000M;

          # Configure timeout
          proxy_read_timeout 600s;
          proxy_send_timeout 600s;
          send_timeout       600s;
        '';
      };
    };
  };
}
