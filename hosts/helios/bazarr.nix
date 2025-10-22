{ ... }:

{
  services.bazarr = {
    enable = true;
    openFirewall = true;
    user = "steixeira";
    group = "media";
  };
  services.lidarr = {
    enable = true;
    openFirewall = true;
    user = "steixeira";
    group = "media";
  };
}
