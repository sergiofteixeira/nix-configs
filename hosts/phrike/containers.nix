{ pkgs, ... }:

{
  config.virtualisation.oci-containers.containers = {
    flaresolverr = {
      image = "flaresolverr/flaresolverr:latest";
      ports = [ "8191:8191" ];
    };

    unifi = {
      image = "lscr.io/linuxserver/unifi-controller:latest";
      ports = [
        "8443:8443"
        "3478:3478"
        "8080:8080"
        "10001"
      ];
      volumes = [ "/home/steixeira/unifi/config:/config" ];
    };
    split = {
      image = "sergioteix/spliit:latest";
      ports = [ "3000" ];
      extraOptions = [ "--network=host" ];
      environment = {
        POSTGRES_PRISMA_URL = "postgresql://split:split@localhost/split";
        POSTGRES_URL_NON_POOLING = "postgresql://split:split@localhost/split";
      };
    };
  };
}
