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
      "linearmouse"
      "orbstack"
      "hammerspoon"
      "gitify"
    ];
    brews = [ "fabianishere/personal/pam_reattach" ];
  };
}
