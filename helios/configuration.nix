# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports = [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
    (fetchTarball
      "https://github.com/nix-community/nixos-vscode-server/tarball/master")
    ./radarr.nix
    ./traefik.nix
    # ./jellyfin.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "helios";
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

  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = false;
  };

  services.vscode-server.enable = true;

  users.users.steixeira = {
    isNormalUser = true;
    description = "Sergio Teixeira";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [ ];
  };

  users.users."steixeira".openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICySDx70VKoXhwoQbGGx1FpZsqWMhJxcOipc76eFztVZ"
  ];

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    neovim
    git
    plex
    radarr
    traefik
    nixfmt
    htop
    jellyfin
    jellyfin-ffmpeg
  ];

  services.plex = {
    dataDir = "/home/steixeira/plex";
    user = "steixeira";
    enable = true;
    openFirewall = true;
  };

  networking.firewall.allowedTCPPorts = [ 80 443 8080 ];
  #networking.firewall.allowedUDPPorts = [ ... ];

  system.stateVersion = "23.05"; # Did you read the comment?

}
