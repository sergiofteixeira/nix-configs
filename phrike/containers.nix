{ config, pkgs, ... }: {
  config.virtualisation.oci-containers.containers = {
    flaresolverr = {
      image = "flaresolverr/flaresolverr:latest";
      ports = [ "8191:8191" ];
    };

    unifi = {
      image = "lscr.io/linuxserver/unifi-controller:latest";
      ports = [ "8443:8443" "3478:3478" "8080:8080" "10001" ];
    };
  };
}
