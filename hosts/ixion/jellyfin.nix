{ ... }:

{
  services.jellyfin = {
    enable = true;
    group = "media";
    openFirewall = true;
  };
  services.seerr = {
    enable = true;
  };
}
