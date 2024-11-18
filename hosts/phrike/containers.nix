{ pkgs, ... }:

{
  config.virtualisation.oci-containers.containers = {
    flaresolverr = {
      image = "flaresolverr/flaresolverr:latest";
      ports = [ "8191:8191" ];
    };

    pihole = {
      autoStart = true;
      image = "pihole/pihole:latest";

      extraOptions = [
        "--cap-add=NET_ADMIN"
        "--network=host"
        "--pull=always"
      ];

      volumes = [
        "/var/lib/etc-pihole:/etc/pihole"
        "/var/lib/etc-dnsmasq.d:/etc/dnsmasq.d"
      ];

      environment = {
        TZ = "Europe/Lisbon";
        ServerIP = "10.200.0.185";
        VIRTUAL_HOST = "pihole.temporalreach.cloud";
        BLOCKING_ENABLED = "true";
        DNSSEC = "false";
        WEB_BIND_ADDR = "10.200.0.185";
        WEBPASSWORD = "webpassword";
        WEBTHEME = "default-dark";
        WEB_PORT = "8053";
        WEBUIBOXEDLAYOUT = "traditional";
      };
    };
  };
}
