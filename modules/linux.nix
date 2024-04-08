{ pkgs, config, ... }:
{
  programs.chromium = {
    enable = true;
    commandLineArgs = [ "--force-device-scale-factor=2 --force-dark-mode" ];
  };

  programs.kitty = {
    enable = true;
    extraConfig = builtins.readFile ./configs/kitty/kitty.conf;
  };
  xsession.pointerCursor = {
    name = "macOS-BigSur";
    package = pkgs.apple-cursor;
    size = 48;
  };
}
