{ ... }:

{
  services.lidarr = {
    enable = true;
    dataDir = "/opt/lidarr";
    group = "media";
    user = "steixeira";
    openFirewall = true;
  };
}
