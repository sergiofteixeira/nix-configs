{ ... }:

{
  services.deluge = {
    enable = true;
    user = "steixeira";
    group = "media";
    web = {
      enable = true;
      openFirewall = true;
      port = 8112;
    };
    config = {
      move_completed = true;
      move_completed_path = "/data/torrents/completed";
      download_location = "/data/torrents/downloading";
      dont_count_slow_torrents = true;
      max_active_seeding = -1;
      max_active_limit = -1;
      max_active_downloading = 8;
      max_connections_global = -1;
      allow_remote = true;
      daemon_port = 58846;
      listen_ports = [
        6881
        6891
      ];
      openFirewall = true;
    };
  };
}
