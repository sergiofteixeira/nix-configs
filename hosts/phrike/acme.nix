{ config, ... }:
let
  dnsProvider = "cloudflare";
  group = "nginx";
in
{
  security.acme.defaults.email = "sergiofpteixeira@gmail.com";
  security.acme.acceptTerms = true;

  # domains

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
