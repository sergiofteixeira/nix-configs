{ ... }:

{
  services.sonarr = {
    enable = true;
    dataDir = "/opt/sonarr";
    user = "steixeira";
    group = "wheel";
    openFirewall = true;
  };
}
