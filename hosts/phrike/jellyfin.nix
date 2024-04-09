{ ... }:

{
  services.jellyfin = {
    user = "steixeira";
    enable = true;
    openFirewall = true;
  };
}
