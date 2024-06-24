{ ... }:

{
  services.radarr = {
    enable = true;
    dataDir = "/opt/radarr";
    group = "media";
    openFirewall = true;
  };
}
