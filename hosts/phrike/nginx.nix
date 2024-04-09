{ config, ... }:
{
  services.nginx = {
    enable = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;
    recommendedGzipSettings = true;
    recommendedOptimisation = true;

    virtualHosts = {
      "unifi.sergioteixeira.xyz" = {
        useACMEHost = "*.sergioteixeira.xyz";
        forceSSL = true;
        locations."/" = {
          proxyPass = "https://localhost:8443";
          proxyWebsockets = true;
        };
      };
      "bazarr.sergioteixeira.xyz" = {
        useACMEHost = "*.sergioteixeira.xyz";
        forceSSL = true;
        locations."/" = {
          proxyPass = "http://localhost:${toString config.services.bazarr.listenPort}";
          proxyWebsockets = true;
        };
      };
      "jellyfin.sergioteixeira.xyz" = {
        useACMEHost = "*.sergioteixeira.xyz";
        forceSSL = true;
        locations."/" = {
          proxyPass = "http://localhost:8096";
          proxyWebsockets = true;
        };
      };
      "plex.sergioteixeira.xyz" = {
        useACMEHost = "*.sergioteixeira.xyz";
        forceSSL = true;
        locations."/" = {
          proxyPass = "http://localhost:32400";
          proxyWebsockets = true;
        };
      };
      "prowlar.sergioteixeira.xyz" = {
        useACMEHost = "*.sergioteixeira.xyz";
        forceSSL = true;
        locations."/" = {
          proxyPass = "http://localhost:9696";
          proxyWebsockets = true;
        };
      };
      "radar.sergioteixeira.xyz" = {
        useACMEHost = "*.sergioteixeira.xyz";
        forceSSL = true;
        locations."/" = {
          proxyPass = "http://localhost:7878";
          proxyWebsockets = true;
        };
      };
      "sonar.sergioteixeira.xyz" = {
        useACMEHost = "*.sergioteixeira.xyz";
        forceSSL = true;
        locations."/" = {
          proxyPass = "http://localhost:8989";
          proxyWebsockets = true;
        };
      };
      "downloader.sergioteixeira.xyz" = {
        useACMEHost = "*.sergioteixeira.xyz";
        forceSSL = true;
        locations."/" = {
          proxyPass = "http://localhost:9091";
          proxyWebsockets = true;
        };
      };
      "vault.sergioteixeira.xyz" = {
        useACMEHost = "*.sergioteixeira.xyz";
        forceSSL = true;
        locations."/" = {
          proxyPass = "http://localhost:8000";
          proxyWebsockets = true;
        };
      };
    };
  };
}
