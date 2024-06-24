{ ... }:
{
  services.plex = {
    dataDir = "/home/steixeira/plex";
    user = "steixeira";
    group = "wheel";
    enable = true;
    accelerationDevices = [
      "/dev/dri/renderD128"
    ]
    openFirewall = true;
  };
}
