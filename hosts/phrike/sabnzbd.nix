{ ... }:

{
  services.sabnzbd = {
    enable = true;
    user = "steixeira";
    group = "media";
    configFile = "/data/sabnzbd/sabnzbd.ini";
  };
}
