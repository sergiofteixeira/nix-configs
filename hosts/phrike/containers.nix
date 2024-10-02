{ pkgs, ... }:

{
  config.virtualisation.oci-containers.containers = {
    flaresolverr = {
      image = "flaresolverr/flaresolverr:latest";
      ports = [ "8191:8191" ];
    };
    containers.pihole = {
      autoStart = true;
      image = "pihole/pihole:latest";

      extraOptions = [
        "--cap-add=NET_ADMIN"
        "--dns=127.0.0.1"
        "--dns=1.1.1.1"
      ];

      volumes = [
        "/var/lib/etc-pihole:/etc/pihole"
        "/var/lib/etc-dnsmasq.d:/etc/dnsmasq.d"
      ];

      environment = {
        TZ = "America/Toronto";
        ServerIP = "100.73.30.58";
        VIRTUAL_HOST = "pihole.sergioteixeira.xyz";
      };

      ports = [
        "53:53/tcp"
        "53:53/udp"
        "8053:80/tcp"
      ];
    };
  };
}
