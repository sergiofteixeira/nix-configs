{ config, pkgs, ... }:

{
  services.radarr = {
    enable = true;
    dataDir = "/opt/radarr";
    user = "steixeira";
    openFirewall = true;
  };
}
