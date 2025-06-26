{ pkgs, ... }:

{
  services.immich = {
    enable = true;
    host = "immich.temporalreach.cloud";
    mediaLocation = "/data/photos";
    settings.server.externalDomain = "https://immich.temporalreach.cloud";
  };
}
