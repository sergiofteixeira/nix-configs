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
      "docker"
      "orbstack"
      "nikitabobko/tap/aerospace"
      "pgadmin4"
      "ghostty"
      "yaak"
    ];
    brews = [
      "fabianishere/personal/pam_reattach"
    ];
  };
}
