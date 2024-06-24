{ ... }:

{
  services.sonarr = {
    enable = true;
    dataDir = "/opt/sonarr";
    group = "media";
    openFirewall = true;
  };
}
