{ ... }:
let
  dataDir = "/var/lib/readmeabook";
in
{
  systemd.tmpfiles.rules = [
    "d ${dataDir} 0750 root root -"
    "d /data/audiobooks 2775 steixeira media -"
  ];

  # let it reach qbittorrent and prowlarr on the host via host.docker.internal
  networking.firewall.interfaces.docker0.allowedTCPPorts = [
    8080
    9696
  ];

  virtualisation.oci-containers.containers.readmeabook = {
    image = "ghcr.io/kikootwo/readmeabook:latest";
    pull = "always";
    # bridge network: its bundled postgres/redis would clash with host ports 5432/6379
    ports = [ "127.0.0.1:3030:3030" ];
    extraOptions = [ "--add-host=host.docker.internal:host-gateway" ];
    environment = {
      # same owner as qbittorrent so finished downloads can be read and moved
      PUID = "1000";
      PGID = "997";
      UMASK = "002";
      PUBLIC_URL = "https://readmeabook.thehiss.dev";
    };
    volumes = [
      "${dataDir}/config:/app/config"
      "${dataDir}/cache:/app/cache"
      "${dataDir}/pgdata:/var/lib/postgresql/data"
      "${dataDir}/redis:/var/lib/redis"
      # same paths as on the host so qbittorrent's save paths line up
      "/data/torrents:/data/torrents"
      "/data/audiobooks:/data/audiobooks"
    ];
  };
}
