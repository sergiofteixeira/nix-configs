{ config, ... }:
let
  dnsProvider = "cloudflare";
  group = "nginx";
  domain = "temporalreach.cloud";
in
{
  security.acme = {
    acceptTerms = true;
    defaults.email = "sergiofpteixeira@gmail.com";
  };

  security.acme.certs.${domain} = {
    domain = domain;
    extraDomainNames = [
      "bazarr.${domain}"
      "jellyfin.${domain}"
      "prowlar.${domain}"
      "radar.${domain}"
      "sonar.${domain}"
      "jellyseer.${domain}"
      "qbittorrent.${domain}"
      "grafana.${domain}"
      "prometheus.${domain}"
    ];
    dnsProvider = dnsProvider;
    dnsResolver = "1.1.1.1:53";
    group = group;
    dnsPropagationCheck = true;
    credentialsFile = config.age.secrets.cloudflare_token.path;
  };

  age.secrets.cloudflare_token = {
    file = ../../secrets/cloudflare_token.age;
  };
}
