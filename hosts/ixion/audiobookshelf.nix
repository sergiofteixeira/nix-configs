{ ... }:
let
  port = 13378;
in
{
  services.audiobookshelf = {
    enable = true;
    # all interfaces so the readmeabook container can reach it over docker0;
    # the firewall only opens it there, LAN access goes through traefik
    host = "0.0.0.0";
    inherit port;
    group = "media";
  };

  networking.firewall.interfaces.docker0.allowedTCPPorts = [ port ];
}
