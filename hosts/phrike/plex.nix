{ ... }:
{
  services.plex = {
    enable = true;
    group = "media";
    accelerationDevices = [ "/dev/dri/renderD128" ];
    openFirewall = true;
  };
}
