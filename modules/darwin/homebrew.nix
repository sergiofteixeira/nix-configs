{ ... }:
{
  homebrew = {
    enable = true;
    casks = [
      "1password"
      "helium"
      "orbstack"
      "pgadmin4"
      "raycast"
      "shottr"
      "slack"
      "tailscale-app"
      "visual-studio-code"
    ];
    brews = [
      "fabianishere/personal/pam_reattach"
    ];
  };
}
