{ config, ... }:
let
  dnsProvider = "cloudflare";
  group = "nginx";
in
{
  security.acme.defaults.email = "sergiofpteixeira@gmail.com";
  security.acme.acceptTerms = true;

  # domains

  security.acme.certs."*.sergioteixeira.xyz" = {
    group = group;
    dnsProvider = dnsProvider;
    credentialsFile = config.age.secrets.cloudflare_token.path;
  };

  age.secrets.cloudflare_token = {
    file = ../../secrets/cloudflare_token.age;
  };
}
