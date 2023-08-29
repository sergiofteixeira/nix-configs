{ config, pkgs, ... }:

let
  unstableTarball = fetchTarball {
      url = "https://github.com/NixOS/nixpkgs/archive/nixos-unstable.tar.gz";
      sha256 = "sha256:178smvv8f8pashdjcr9bhmp0baji0lhfcxqy3cn7m19g8rgd6539";
    };
in {

  imports = [
    ./hardware-configuration.nix
    ./traefik.nix
    ./radarr.nix
    ./sonarr.nix
    ./prowlarr.nix
    ./bazarr.nix
    ./transmission.nix
    ./flaresolverr.nix
    ./plex.nix
    ./tailscale.nix
    ./node-exporter.nix
    ./unifi.nix
    ./jellyfin.nix
  ];

  nixpkgs.config = {
    packageOverrides = pkgs: {
      unstable = import unstableTarball { config = config.nixpkgs.config; };
    };
  };

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "phrike";
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

  services.xserver = {
    layout = "us";
    xkbVariant = "";
  };

  users.users.steixeira = {
    isNormalUser = true;
    description = "steixeira";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [ ];
  };

  users.users."steixeira".openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICySDx70VKoXhwoQbGGx1FpZsqWMhJxcOipc76eFztVZ"
  ];

  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = false;
  };

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    neovim
    git
    nixfmt
    plex
    radarr
    sonarr
    prowlarr
    bazarr
    traefik
    htop
    jellyfin
    jellyfin-ffmpeg
    tailscale
    prometheus-node-exporter
    unifi
    intel-gpu-tools
    ncdu
    unstable.transmission_4
  ];

  networking.firewall = {
    enable = true;

    # always allow traffic from your Tailscale network
    trustedInterfaces = [ "tailscale0" ];

    # allow the Tailscale UDP port through the firewall
    allowedUDPPorts = [ config.services.tailscale.port ];

    # allow you to SSH in over the public internet
    allowedTCPPorts = [ 80 443 ];
  };

  services.vscode-server.enable = true;
  system.stateVersion = "23.05"; # Did you read the comment?

}
