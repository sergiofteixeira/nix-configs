{ pkgs, config, ... }:
{
  imports = [
    ./bank-split.nix
    ./bazarr.nix
    ./containers.nix
    ./disko-config.nix
    ./forgejo.nix
    ./hardware-configuration.nix
    ./home-assistant.nix
    ./jellyfin.nix
    ../../modules/monitoring/grafana.nix
    ../../modules/monitoring/node-monitoring.nix
    ../../modules/monitoring/prometheus.nix
    ./prowlarr.nix
    ./qbittorrent.nix
    ./radarr.nix
    ./sonarr.nix
    ./tailscale.nix
    ./traefik.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernel.sysctl = {
    "net.ipv4.ip_forward" = 1;
    "net.ipv6.conf.all.forwarding" = 1;
  };

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  nix.settings.trusted-users = [ "steixeira" ];
  nix.gc.automatic = true;
  nix.gc.options = "--delete-older-than 7d";

  networking.hostName = "ixion";
  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Lisbon";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "pt_PT.UTF-8";
    LC_IDENTIFICATION = "pt_PT.UTF-8";
    LC_MEASUREMENT = "pt_PT.UTF-8";
    LC_MONETARY = "pt_PT.UTF-8";
    LC_NAME = "pt_PT.UTF-8";
    LC_NUMERIC = "pt_PT.UTF-8";
    LC_PAPER = "pt_PT.UTF-8";
    LC_TELEPHONE = "pt_PT.UTF-8";
    LC_TIME = "pt_PT.UTF-8";
  };

  users.groups.media = { };
  users.users.steixeira = {
    isNormalUser = true;
    description = "steixeira";
    extraGroups = [
      "networkmanager"
      "wheel"
      "media"
      "docker"
    ];
    packages = with pkgs; [ ];
    shell = pkgs.fish;
  };

  users.users."steixeira".openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMW9rLAo0TcvX4/VcuivIJVmDQ8G7hANhVn18Zdbrm9y"
  ];

  security.sudo.extraRules = [
    {
      users = [ "steixeira" ];
      commands = [
        {
          command = "ALL";
          options = [ "NOPASSWD" ];
        }
      ];
    }
  ];
  programs.zsh.enable = true;

  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = false;
    extraConfig = ''
      KeepAlive yes
      ClientAliveInterval 300
      ClientAliveCountMax 15
    '';
  };

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    neovim
    ncdu
    flac2all
    git
    htop
    intel-gpu-tools
    libva-utils
    tailscale
    gcc
    ffmpeg
  ];

  users.users.jellyfin.extraGroups = [
    "render"
    "video"
  ];
  systemd.services.jellyfin.environment.LIBVA_DRIVER_NAME = "iHD";

  virtualisation = {
    docker.enable = true;
    docker.storageDriver = "overlay2";
    oci-containers.backend = "docker";
  };

  networking.firewall = {
    enable = false;
    trustedInterfaces = [ "tailscale0" ];
    allowedUDPPorts = [ config.services.tailscale.port ];
    allowedTCPPorts = [
      80
      443
    ];
  };

  programs.fish.enable = true;

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  system.stateVersion = "23.05";
}
