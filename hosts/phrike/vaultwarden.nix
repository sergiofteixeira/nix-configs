{ ... }:

{
  services.vaultwarden = {
    enable = true;
    backupDir = "/backup-disk/vaultwarden";
  };
}
