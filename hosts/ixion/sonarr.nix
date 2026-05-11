{ ... }:

{
  services.sonarr = {
    enable = true;
    group = "media";
    user = "steixeira";
    openFirewall = true;
  };
}
