{ config, ... }:
let
  dnsProvider = "cloudflare";
  group = "nginx";
in
{
  security.acme = {
    acceptTerms = true;
    defaults.email = "sergiofpteixeira@gmail.com";
    defaults = {
      dnsProvider = dnsProvider;
      reloadServices = [
        group
      ];
    };
  };

  security.acme.certs."temporalreach.cloud" = {
    group = group;
    dnsProvider = dnsProvider;
    credentialsFile = config.age.secrets.cloudflare_token.path;
    extraDomainNames = [ "*.temporalreach.cloud" ];
  };

  age.secrets.cloudflare_token = {
    file = ../../secrets/cloudflare_token.age;
  };
}
