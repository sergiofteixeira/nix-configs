{ ... }:

{
  services.transmission = {
    user = "steixeira";
    group = "media";
    enable = true;
    settings.rpc-authentication-required = false;
    settings.download-queue-enabled = false;
    settings.rpc-bind-address = "0.0.0.0";
    settings.rpc-host-whitelist-enabled = false;
    settings.rpc-whitelist-enabled = false;
    settings.trash-original-torrent-files = true;
    settings.download-dir = "/data/downloads";
    settings.incomplete-dir = "/data/incomplete-downloads";
    openFirewall = true;
    downloadDirPermissions = "777";
  };
}
