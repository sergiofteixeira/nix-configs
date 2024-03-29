{ config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ../../mixins/fonts.nix
    ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = true;
  };

  networking.hostName = "nemesis";
  networking.wireless.enable = false;
  networking.wireless.userControlled.enable = true;
  networking.wireless.networks."Quintaz Laurazz Farmzzz".pskRaw = "ef02b72e4ef4fced065234ed2ffef652fadaafaca69328b2be5c925cae5a77f3";
  networking.networkmanager.enable = false;
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

  services.xserver = {
    dpi = 192;
    enable = true;
    videoDrivers = [ "amdgpu" ];
    displayManager = {
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

  services.tailscale.enable = true;

  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  users.users.steixeira = {
    isNormalUser = true;
    description = "Sergio Teixeira";
    extraGroups = [ "networkmanager" "wheel" ];
    shell = pkgs.fish;
    packages = with pkgs; [
    ];
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

  environment.variables.XCURSOR_SIZE = "48";
  #environment.variables.STEAM_FORCE_DESKTOPUI_SCALING = "2";

  nixpkgs.config.allowUnfree = true;
  programs.fish.enable = true;


  environment.systemPackages = with pkgs; [
    sunshine
    mprime
    sddm-chili-theme
    gcc
    neovim
    git
    vulkan-tools
    mangohud
  ];

  programs.steam = {
    enable = true;
  };


  networking.firewall.enable = false;
  system.stateVersion = "23.11";

}
