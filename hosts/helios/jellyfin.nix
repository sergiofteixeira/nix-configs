{ ... }:

{
  services.jellyfin = {
    enable = true;
    group = "media";
    openFirewall = true;
  };
  services.jellyseerr = {
    enable = true;
  };
}
