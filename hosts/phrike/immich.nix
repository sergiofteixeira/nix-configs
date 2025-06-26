{ pkgs, config, ... }:

{
  services.immich = {
    enable = true;
    host = "immich.temporalreach.cloud";
    mediaLocation = "/data/photos";
    settings.server.externalDomain = "https://immich.temporalreach.cloud";
  };

  systemd.timers."immichBackup" = {
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "daily";
      Persistent = true;
      Unit = "immichBackup.service";
    };
  };

  systemd.services."immichBackup" = {
    script = ''
      BACKUP_DIR="/backup-disk/immich"
      DB_DUMP="$BACKUP_DIR/immich-db.sql"

      mkdir -p "$BACKUP_DIR"

      echo "Syncing photos..."
      ${pkgs.rsync}/bin/rsync -av --delete /data/photos/ "$BACKUP_DIR/photos/"

      echo "Dumping PostgreSQL Immich DB..."
      ${pkgs.postgresql}/bin/pg_dump -U immich -h /run/postgresql immich > "$DB_DUMP"

      echo "Immich backup completed: $BACKUP_DIR"
    '';
    path = [
      pkgs.rsync
      pkgs.coreutils
      pkgs.postgresql
    ];
    serviceConfig = {
      Type = "oneshot";
      User = "immich";
    };
  };
}
