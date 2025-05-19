{ ... }:
{
  homebrew = {
    enable = true;
    caskArgs.no_quarantine = true;
    casks = [
      "alt-tab"
      "1password"
      "visual-studio-code"
      "google-chrome"
      "slack"
      "raycast"
      "spotify"
      "tailscale"
      "orbstack"
      "nikitabobko/tap/aerospace"
      "pgadmin4"
      "brave-browser"
      "ghostty"
    ];
    brews = [
      "fabianishere/personal/pam_reattach"
    ];
  };
}
