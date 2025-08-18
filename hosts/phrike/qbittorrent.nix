{ pkgs, ... }:
{
  services.qbittorrent = {
    enable = true;
    package = inputs.qbit.legacyPackages.${pkgs.system}.qbittorrent-nox;
    group = "media";
    serverConfig = {
      LegalNotice.Accepted = true;
      BitTorrent.Session = rec {
        TempPathEnabled = true;
        DefaultSavePath = "/storage/media/torrents/";
        TempPath = DefaultSavePath + "incomplete/";
        TorrentExportDirectory = DefaultSavePath + "sources/";
        QueueingSystemEnabled = true;
        IgnoreSlowTorrentsForQueueing = true;
        SlowTorrentsDownloadRate = 40; # kbps
        SlowTorrentsUploadRate = 40; # kbps
        GlobalMaxInactiveSeedingMinutes = 43800;
        GlobalMaxSeedingMinutes = 10080;
        GlobalMaxRatio = 2;
        MaxActiveCheckingTorrents = 2;
        MaxActiveDownloads = 5;
        MaxActiveUploads = 15;
        MaxActiveTorrents = 20;
        MaxConnections = 600;
        MaxUploads = 200;
      };
      Preferences.WebUI = {
        AlternativeUIEnabled = true;
        RootFolder = "${pkgs.vuetorrent}";
        AuthSubnetWhitelist = "0.0.0.0/0";
        AuthSubnetWhitelistEnabled = true;
      };
    };
  };
}
