# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ pkgs, ... }:
let
  steam_autostart = (pkgs.makeAutostartItem { name = "steam"; package = pkgs.steam; });
in
{
  imports = [
    ./hardware-configuration.nix
    ../../mixins/fonts.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "helios";
  networking.wireless.enable = true;
  networking.wireless.userControlled.enable = true;
  networking.wireless.networks."Quintaz Laurazz Farmzzz".pskRaw = "ef02b72e4ef4fced065234ed2ffef652fadaafaca69328b2be5c925cae5a77f3";
  networking.networkmanager.enable = false;

  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  hardware.bluetooth.settings = {
    General = {
      Enable = "Source,Sink,Media,Socket";
      Experimental = true;
    };
  };

  # Enable Docker and set to backend (over podman default)
  virtualisation = {
    docker.enable = true;
    docker.storageDriver = "overlay2";
    oci-containers.backend = "docker";
  };

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.settings.trusted-users = [ "steixeira" ];
  nix.gc.automatic = true;
  nix.gc.options = "--delete-older-than 7d";

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

  services.blueman.enable = true;
  services.getty.autologinUser = "steixeira";
  services.tailscale.enable = true;
  services.tailscale.useRoutingFeatures = "both";

  services.xserver = {
    dpi = 192;
    enable = true;
    displayManager = {
      autoLogin = {
        enable = true;
        user = "steixeira";
      };
      sddm = {
        enable = true;
        theme = "chili";
        settings = {
          X11 = {
            ServerArguments = "-dpi 192";
            EnableHiDPI = true;
          };
          Theme = {
            CursorTheme = "macOS-BigSur";
            CursorSize = 48;
          };
        };
      };
      defaultSession = "none+i3";
    };
    desktopManager = {
      xterm.enable = false;
    };
    windowManager.i3 = {
      enable = true;
      extraPackages = with pkgs; [
        dmenu
        i3lock
      ];
    };
    layout = "us";
    xkbVariant = "";
  };

  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = true;
    settings.PermitRootLogin = "yes";
  };

  users.users.steixeira = {
    isNormalUser = true;
    description = "Sergio Teixeira";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    packages = with pkgs; [ ];
    shell = pkgs.fish;
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
          options = [ "NOPASSWD" ]; # "SETENV" # Adding the following could be a good idea
        }
      ];
    }
  ];

  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.permittedInsecurePackages = [
    "nodejs-16.20.2"
  ];

  environment.variables.XCURSOR_SIZE = "48";

  environment.systemPackages = with pkgs; [
    steam_autostart
    pavucontrol
    sddm-chili-theme
    gcc
    neovim
    git
  ];

  programs.fish.enable = true;

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  programs.steam = {
    enable = true;
    gamescopeSession.enable = true;
  };
  hardware.steam-hardware.enable = true;

  networking.firewall.enable = false;

  system.stateVersion = "23.05";

}
