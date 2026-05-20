{ ... }:

{
  services.plex = {
    enable = true;
    group = "media";
    openFirewall = true;
  };

  users.users.plex.extraGroups = [
    "render"
    "video"
  ];
}
