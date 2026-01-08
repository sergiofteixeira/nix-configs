{ pkgs, config, ... }:
{
  programs.zsh.enable = true;
  programs.fish.enable = true;
  environment = {
    shells = with pkgs; [
      bash
      zsh
      fish
    ];
    systemPackages = [ pkgs.coreutils ];
    systemPath = [ "/opt/homebrew/bin" ];
  };
  users.users."steixeira".shell = pkgs.fish;
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';
  nixpkgs.config.allowUnfree = true;
  nix.enable = false;

  nix.settings.trusted-users = [ "steixeira" ];
  system.keyboard.enableKeyMapping = true;
  system.keyboard.remapCapsLockToEscape = true;

  system.keyboard.userKeyMapping =
    let
      fn = 1095216660483;
      left_control = 30064771296;
    in
    [
      {
        HIDKeyboardModifierMappingSrc = fn;
        HIDKeyboardModifierMappingDst = left_control;
      }
    ];

  security.pam.services.sudo_local.touchIdAuth = true;

  fonts.packages = [
    pkgs.nerd-fonts.meslo-lg
    pkgs.nerd-fonts.jetbrains-mono
    pkgs.nerd-fonts.geist-mono
    pkgs.nerd-fonts.terminess-ttf
  ];

  system.primaryUser = "steixeira";
  system.defaults = {

    finder.AppleShowAllExtensions = true;
    finder._FXShowPosixPathInTitle = true;
    finder.CreateDesktop = true;

    dock.autohide = false;
    dock.autohide-delay = 1.0e-2;
    dock.autohide-time-modifier = 1.0e-2;
    dock.show-recents = false;

    CustomSystemPreferences = {
      NSGlobalDomain = {
        NSWindowShouldDragOnGesture = true;
      };
    };

    NSGlobalDomain = {
      "com.apple.sound.beep.feedback" = 0;
      "com.apple.sound.beep.volume" = 0.0;

      AppleKeyboardUIMode = 3;
      AppleInterfaceStyle = "Dark";
      AppleInterfaceStyleSwitchesAutomatically = false;

      ApplePressAndHoldEnabled = false;
      InitialKeyRepeat = 15;
      KeyRepeat = 2;
      AppleShowAllExtensions = true;
      AppleShowScrollBars = "Automatic";

      NSWindowResizeTime = 0.1;

      NSAutomaticWindowAnimationsEnabled = false;
    };
  };
}
