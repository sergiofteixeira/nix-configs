{ pkgs, ... }:

{
  config.virtualisation.oci-containers.containers = {
    flaresolverr = {
      image = "flaresolverr/flaresolverr:latest";
      ports = [ "8191:8191" ];
    };
  };
}
