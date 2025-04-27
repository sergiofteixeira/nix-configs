{ ... }:

{
  services.sabnzbd = {
    enable = true;
    user = "jellyfin";
    group = "media";
  };
}
