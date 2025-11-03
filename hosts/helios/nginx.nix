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
      "jellyseer.temporalreach.cloud" = {
        useACMEHost = acmeHost;
        forceSSL = true;
        locations."/" = {
          proxyPass = "http://localhost:5055";
        };
      };
      "qbittorrent.temporalreach.cloud" = {
        useACMEHost = acmeHost;
        forceSSL = true;
        locations."/" = {
          proxyPass = "http://localhost:8080";
        };
      };
      "grafana.temporalreach.cloud" = {
        useACMEHost = acmeHost;
        forceSSL = true;
        locations."/" = {
          proxyPass = "http://localhost:3000";
        };
      };
      "prometheus.temporalreach.cloud" = {
        useACMEHost = acmeHost;
        forceSSL = true;
        locations."/" = {
          proxyPass = "http://localhost:9090";
        };
      };
    };
  };
}
