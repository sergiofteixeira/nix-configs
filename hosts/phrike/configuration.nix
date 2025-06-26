{
  config,
  pkgs,
  inputs,
  ...
}:

{
  imports = [
    ./acme.nix
    ./bazarr.nix
    ./containers.nix
    ./deluge.nix
    ./hardware-configuration.nix
    ./immich.nix
    inputs.comin.nixosModules.comin
    inputs.vscode-server.nixosModules.default
    ./jellyfin.nix
    ../../modules/beszel-agent.nix
    ./nginx.nix
    ./prowlarr.nix
    ./radarr.nix
    ./rqbit.nix
    ./sonarr.nix
    ./tailscale.nix
  ];

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  nix.settings.trusted-users = [ "steixeira" ];
  nix.gc.automatic = true;
  nix.gc.options = "--delete-older-than 7d";

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "phrike";
  networking.networkmanager.enable = true;
  networking.interfaces.eno1.wakeOnLan = {
    enable = true;
  };

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
  services.xserver = {
    xkb.layout = "us";
    xkb.variant = "";
  };

  users.users.beszel = {
    isSystemUser = true;
    group = "beszel";
    description = "Beszel Agent service user";
  };
  users.groups.beszel = { };
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
    shell = pkgs.zsh;
  };

  users.users."steixeira".openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICySDx70VKoXhwoQbGGx1FpZsqWMhJxcOipc76eFztVZ"
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

  nixpkgs.config.permittedInsecurePackages = [
    "aspnetcore-runtime-6.0.36"
    "aspnetcore-runtime-wrapped-6.0.36"
    "dotnet-sdk-wrapped-6.0.428"
    "dotnet-sdk-6.0.428"
  ];

  environment.systemPackages = with pkgs; [
    neovim
    git
    nixfmt-rfc-style
    plex
    radarr
    sonarr
    prowlarr
    bazarr
    htop
    tailscale
    prometheus-node-exporter
    intel-gpu-tools
    ncdu
    transmission_4
    gnumake
    beszel
  ];

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

  services.vscode-server.enable = true;

  services.prometheus.enable = true;

  age.secrets.git_token = {
    file = ../../secrets/token.age;
    mode = "775";
  };

  services.comin = {
    enable = true;
    remotes = [
      {
        name = "origin";
        url = "https://github.com/sergiofteixeira/nix-configs.git";
        branches.main.name = "main";
      }
    ];
  };

  systemd.services.beszel-agent = {
    description = "Beszel Agent Service";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];

    serviceConfig = {
      Environment = [
        "EXTRA_FILESYSTEMS=\"sda1\""
        "PORT=45876"
        ''KEY="ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEbtqGTTZNXdQTQzuMQn4gyDheBdtV9T9W9MUCdX0dJY"''
      ];
      ExecStart = "/run/current-system/sw/bin/beszel-agent";
      User = "beszel";
      Restart = "always";
      RestartSec = 5;
    };
  };

  system.stateVersion = "23.05";
}
