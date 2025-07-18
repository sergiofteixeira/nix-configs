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
    domain = "*.${domain}";
    dnsProvider = dnsProvider;
    dnsResolver = "1.1.1.1:53";
    group = group;
    dnsPropagationCheck = false;
    credentialsFile = config.age.secrets.cloudflare_token.path;
  };

  age.secrets.cloudflare_token = {
    file = ../../secrets/cloudflare_token.age;
  };
}
