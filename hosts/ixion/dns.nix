{ ... }:

{
  # This network transparently intercepts all plaintext DNS on UDP/53 and
  # sinkholes some domains to 0.0.0.0 (notably *.radarr.video, which breaks
  # Radarr's metadata lookups). Naming a different resolver does not help --
  # the interception applies regardless of which server is queried. Resolving
  # over TLS on port 853 bypasses it.
  services.resolved = {
    enable = true;
    settings.Resolve = {
      DNSOverTLS = "true"; # strict: fail rather than silently fall back to plaintext
      DNSSEC = "false";
      FallbackDNS = [ ]; # no plaintext fallbacks
    };
  };

  # The #hostname suffix is the name systemd-resolved validates the DoT
  # certificate against.
  networking.nameservers = [
    "1.1.1.1#cloudflare-dns.com"
    "1.0.0.1#cloudflare-dns.com"
    "2606:4700:4700::1111#cloudflare-dns.com"
    "2606:4700:4700::1001#cloudflare-dns.com"
  ];

  networking.networkmanager.dns = "systemd-resolved";
}
