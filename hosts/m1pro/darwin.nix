{ pkgs, ... }: {
  # here go the darwin preferences and config items
  programs.zsh.enable = true;
  programs.fish.enable = true;
  environment = {
    shells = with pkgs; [ bash zsh fish ];
    systemPackages = [ pkgs.coreutils ];
    systemPath = [ "/opt/homebrew/bin" ];
  };
  users.users."steixeira".shell = pkgs.fish;
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';
  nixpkgs.config.allowUnfree = true;

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

  security.pam.enableSudoTouchIdAuth = true;

  fonts.fontDir.enable = true; # DANGER
  fonts.fonts = [ (pkgs.nerdfonts.override { fonts = [ "Meslo" ]; }) ];

  services.nix-daemon.enable = true;

  networking = {
    hostName = "TARS";
  };

  system.defaults = {

    finder.AppleShowAllExtensions = true;
    finder._FXShowPosixPathInTitle = true;
    finder.CreateDesktop = true;

    dock.autohide = false;
    dock.autohide-delay = 1.0e-2;
    dock.autohide-time-modifier = 1.0e-2;
    dock.show-recents = false;

    CustomSystemPreferences = {
      NSGlobalDomain = { NSWindowShouldDragOnGesture = true; };
    };

    NSGlobalDomain = {
      "com.apple.sound.beep.feedback" = 0;
      "com.apple.sound.beep.volume" = 0.0;

      AppleKeyboardUIMode = 3;
      AppleInterfaceStyle = "Dark";
      AppleInterfaceStyleSwitchesAutomatically = false;

      ApplePressAndHoldEnabled = false;
      InitialKeyRepeat = 15; # normal minimum is 15 (225 ms)
      KeyRepeat = 2; # normal minimum is 2 (30 ms)
      AppleShowAllExtensions = true;
      AppleShowScrollBars = "Automatic";

      NSWindowResizeTime = 0.1;

      NSAutomaticWindowAnimationsEnabled = false;
    };
  };

  system.stateVersion = 4;
  homebrew = {
    enable = true;
    caskArgs.no_quarantine = true;
    casks = [ "alt-tab" "betterdisplay" "1password" "visual-studio-code" "google-chrome" "slack" "raycast" "spotify" "tailscale" "docker" "linearmouse" "orbstack" "devutils"];
    brews = [ "fabianishere/personal/pam_reattach" ];
  };
}

