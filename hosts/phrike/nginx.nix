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
      "downloader.temporalreach.cloud" = {
        useACMEHost = acmeHost;
        forceSSL = true;
        locations."/" = {
          proxyPass = "http://localhost:9091";
          proxyWebsockets = true;
        };
      };
      "adguard.temporalreach.cloud" = {
        useACMEHost = acmeHost;
        forceSSL = true;
        locations."/" = {
          proxyPass = "http://localhost:3000";
          proxyWebsockets = true;
        };
      };
    };
  };
}
