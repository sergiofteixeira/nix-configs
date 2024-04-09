{ ... }:

{
  services.radarr = {
    enable = true;
    dataDir = "/opt/radarr";
    user = "steixeira";
    group = "wheel";
    openFirewall = true;
  };
}
