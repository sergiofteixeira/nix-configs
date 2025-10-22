{ ... }:

{
  services.sonarr = {
    enable = true;
    dataDir = "/opt/sonarr";
    group = "media";
    user = "steixeira";
    openFirewall = true;
  };
}
