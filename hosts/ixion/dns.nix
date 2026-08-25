{ ... }:

{
  # Use Cloudflare resolvers rather than whatever DHCP hands out.
  # NetworkManager is told not to manage resolv.conf so these are authoritative.
  networking.nameservers = [
    "1.1.1.1"
    "1.0.0.1"
    "2606:4700:4700::1111"
    "2606:4700:4700::1001"
  ];
  networking.networkmanager.dns = "none";
}
