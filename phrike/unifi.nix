{ config, pkgs, ... }: {
  config.virtualisation.oci-containers.containers = {
    unifi = {
      image = "lscr.io/linuxserver/unifi-controller:latest";
      ports = [ "8443:8443" "3478:3478" "8080:8080" "10001" ];
    };
  };

  services.traefik.dynamicConfigOptions.http = {
    routers.unifi = {
      entryPoints = [ "https" ];
      rule = "Host(`unifi.nathil.com`)";
      service = "unifi";

      tls = {
        certResolver = "nathilcom";
        domains = [{ main = "*.nathil.com"; }];
      };
    };
  };
}
