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
      "pgadmin4"
      "devpod"
      "datagrip"
    ];
    brews = [ "fabianishere/personal/pam_reattach" ];
  };
}
