{ config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ./fonts.nix
    ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = true;
  };

  networking.hostName = "nemesis";
  networking.wireless.enable = true;
  networking.networkmanager.enable = true;
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

  nixpkgs.config.allowUnfree = true;
  programs.fish.enable = true;


  environment.systemPackages = with pkgs; [
    sddm-chili-theme
    gcc
    neovim
    git
    vimPlugins.packer-nvim
  ];


  networking.firewall.enable = false;
  home.file = {
    ".config/nvim" = {
      recursive = true;
      source = pkgs.fetchFromGitHub {
        owner = "sergiofteixeira";
        repo = "nvim";
        rev = "9dba2a9df4def169a262e0fedc174edd1cc5a6b7";
        sha256 = "sha256-h1bMsTzrMgKmgPO+7/aTOYlFMeedAnY4piQO3grtOHc=";
      };
    };
  };
  system.stateVersion = "23.11"; # Did you read the comment?

}
