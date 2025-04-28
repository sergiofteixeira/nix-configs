{ ... }:

{
  services.deluge = {
    enable = true;
    user = "nobody";
    group = "nogroup";
    web = {
      enable = true;
      openFirewall = true;
      port = 8112;
    };
    config = {
      download_location = "/data/downloads/";
      allow_remote = true;
      daemon_port = 58846;
      listen_ports = [
        6881
        6891
      ];
      pre_allocate_storage = true;
      prioritize_first_last_pieces = true;
      sequential_download = true;
      stop_seed_at_ratio = true;
      stop_seed_ratio = 1.0;
      share_ratio_limit = 1.0;
      openFirewall = true;
    };
  };
}
