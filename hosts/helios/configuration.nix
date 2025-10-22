{ pkgs, config, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../../modules/monitoring/grafana.nix
    ../../modules/monitoring/prometheus.nix
    ../../modules/monitoring/node-monitoring.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  nix.settings.trusted-users = [ "steixeira" ];
  nix.gc.automatic = true;
  nix.gc.options = "--delete-older-than 7d";

  networking.hostName = "helios";
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

  environment.systemPackages = with pkgs; [
    neovim
    ncdu
    git
    htop
    intel-gpu-tools
    tailscale
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
