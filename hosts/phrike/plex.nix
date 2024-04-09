{ ... }:
{
  services.plex = {
    dataDir = "/home/steixeira/plex";
    user = "steixeira";
    enable = true;
    openFirewall = true;
  };
}
