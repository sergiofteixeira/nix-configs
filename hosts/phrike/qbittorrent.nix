{ pkgs, ... }:
{
  services.qbittorrent = {
    enable = true;
    package = pkgs.qbittorrent-nox;
    user = "steixeira";
    group = "media";
    serverConfig = {
      LegalNotice.Accepted = true;
      BitTorrent.Session = rec {
        TempPathEnabled = true;
        DefaultSavePath = "/data/torrents/";
        TempPath = DefaultSavePath + "incomplete/";
        TorrentExportDirectory = DefaultSavePath + "sources/";
        QueueingSystemEnabled = true;
        IgnoreSlowTorrentsForQueueing = true;
        SlowTorrentsDownloadRate = 40;
        SlowTorrentsUploadRate = 40;
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
        RootFolder = "${pkgs.vuetorrent}/share/vuetorrent";
        AuthSubnetWhitelist = "0.0.0.0/0";
        AuthSubnetWhitelistEnabled = true;
      };
    };
  };
}
