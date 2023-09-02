{ config, lib, pkgs, ... }:
{
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/vda";
  boot.loader.grub.useOSProber = true;

  console.font = lib.mkDefault "${pkgs.terminus_font}/share/consolefonts/ter-u28n.psf.gz";

  networking.hostName = "nixos"; # Define your hostname.
  networking.networkmanager.enable = true;
  time.timeZone = "Europe/Lisbon";
  i18n.defaultLocale = "en_US.UTF-8";

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.settings.trusted-users = [ "steixeira" ];

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
    description = "steixeira";
    extraGroups = [ "networkmanager" "wheel" ];
  };

  users.users."steixeira".openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICySDx70VKoXhwoQbGGx1FpZsqWMhJxcOipc76eFztVZ"
  ];

  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = false;
  };

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
  environment.systemPackages = with pkgs; [
    inter
    neovim
    gcc
    kitty
    vscode
    google-chrome
    slack
    xdg-desktop-portal-wlr
    terminus_font
    pgadmin4-desktopmode
    trayscale
    firefox
  ];

  services.tailscale.enable = true;
  services.xserver.enable = false;
  services.xserver.displayManager.gdm.enable = false;
  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true; # so that gtk works properly
    extraPackages = with pkgs; [
      i3status
      swaylock
      swayidle
      wl-clipboard
      wf-recorder
      mako
      grim
      slurp
      wofi
      wdisplays
      _1password-gui
    ];
    extraSessionCommands = ''
      export SDL_VIDEODRIVER=wayland
      export QT_QPA_PLATFORM=wayland
      export QT_WAYLAND_DISABLE_WINDOWDECORATION="1"
      export _JAVA_AWT_WM_NONREPARENTING=1
      export MOZ_ENABLE_WAYLAND=1
    '';
  };

  services.qemuGuest.enable = true;
  services.spice-vdagentd.enable = true;

  programs.bash = {
    loginShellInit = ''
      if [ -z $DISPLAY ] && [ "$(tty)" = "/dev/tty1" ]; then
        exec sway
      fi
    '';
  };

  security.polkit.enable = true;

  system.stateVersion = "23.05"; # Did you read the comment?

}
