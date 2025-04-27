{ ... }:

{
  services.sabnzbd = {
    enable = true;
    user = "jellyfin";
    group = "media";
    configFile = "/data/sabnzbd/sabnzbd.ini";
  };
}
