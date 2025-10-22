{ ... }:

{
  services.radarr = {
    enable = true;
    dataDir = "/opt/radarr";
    group = "media";
    user = "steixeira";
    openFirewall = true;
  };
}
