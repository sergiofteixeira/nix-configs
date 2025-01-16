{ pkgs, ... }:

{
  config.virtualisation.oci-containers.containers = {
    flaresolverr = {
      image = "flaresolverr/flaresolverr:latest";
      ports = [ "8191:8191" ];
    };

    beszel-hub = {
      image = "henrygd/beszel:0.9";
      ports = [ "8090:8090" ];

      volumes = [
        "/var/lib/beszel:/beszel_data"
        "/var/lib/etc-dnsmasq.d:/etc/dnsmasq.d"
      ];
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
