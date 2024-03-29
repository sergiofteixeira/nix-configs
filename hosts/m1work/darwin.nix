{ pkgs, ... }: {
  # here go the darwin preferences and config items
  programs.fish.enable = true;
  environment = {
    shells = with pkgs; [ fish ];
    systemPackages = [ pkgs.coreutils ];
    systemPath = [ "/opt/homebrew/bin" ];
  };
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';
  nixpkgs.config.allowUnfree = true;

  system.activationScripts.postActivation.text = ''
    ln -sfn /run/current-system/sw/bin/ /usr/local/bin
    ln -sfn /run/current-system/sw/lib/ /usr/local/lib
  '';

  nix.settings.trusted-users = [ "steixeira" ];
  system.keyboard.enableKeyMapping = true;
  system.keyboard.remapCapsLockToEscape = true;
  users.users.steixeira.shell = pkgs.fish;

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

  services.nix-daemon.enable = true;

  networking = {
    hostName = "CASE";
  };

  system.defaults = {

    finder.AppleShowAllExtensions = true;
    finder._FXShowPosixPathInTitle = true;
    finder.CreateDesktop = true;

    dock.autohide = false;
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
    casks = [ "alt-tab" "1password" "visual-studio-code" "google-chrome" "slack" "raycast" "spotify" "tailscale" "docker" "linearmouse" "orbstack" "hammerspoon" "pgadmin4" "devpod" ];
    brews = [ "fabianishere/personal/pam_reattach" ];
  };
}

