{ ... }:

{
  services.jellyfin = {
    enable = true;
    group = "media";
    openFirewall = true;
  };
  services.seer = {
    enable = true;
  };
}
