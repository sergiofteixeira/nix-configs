{ config, ... }:
let
  acmeHost = "sergioteixeira.xyz";
in
{
  services.nginx = {
    enable = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;
    recommendedGzipSettings = true;
    recommendedOptimisation = true;

    virtualHosts = {
      "pihole.sergioteixeira.xyz" = {
        useACMEHost = acmeHost;
        forceSSL = true;
        locations."/" = {
          proxyPass = "http://localhost:8053";
          proxyWebsockets = true;
        };
      };
      "bazarr.sergioteixeira.xyz" = {
        useACMEHost = acmeHost;
        forceSSL = true;
        locations."/" = {
          proxyPass = "http://localhost:${toString config.services.bazarr.listenPort}";
          proxyWebsockets = true;
        };
      };
      "jellyfin.sergioteixeira.xyz" = {
        useACMEHost = acmeHost;
        forceSSL = true;
        locations."/" = {
          proxyPass = "http://localhost:8096";
          proxyWebsockets = true;
        };
      };
      "prowlar.sergioteixeira.xyz" = {
        useACMEHost = acmeHost;
        forceSSL = true;
        locations."/" = {
          proxyPass = "http://localhost:9696";
          proxyWebsockets = true;
        };
      };
      "radar.sergioteixeira.xyz" = {
        useACMEHost = acmeHost;
        forceSSL = true;
        locations."/" = {
          proxyPass = "http://localhost:7878";
          proxyWebsockets = true;
        };
      };
      "sonar.sergioteixeira.xyz" = {
        useACMEHost = acmeHost;
        forceSSL = true;
        locations."/" = {
          proxyPass = "http://localhost:8989";
          proxyWebsockets = true;
        };
      };
      "downloader.sergioteixeira.xyz" = {
        useACMEHost = acmeHost;
        forceSSL = true;
        locations."/" = {
          proxyPass = "http://localhost:9091";
          proxyWebsockets = true;
        };
      };
      "adguard.sergioteixeira.xyz" = {
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
