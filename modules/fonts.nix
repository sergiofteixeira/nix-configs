{ pkgs, lib, ... }:
{
  fonts = {
    enableDefaultPackages = true;
    fontDir.enable = true; # ls /run/current-system/sw/share/X11/fonts/
    fontconfig = {
      enable = true;
      cache32Bit = true;
      hinting.enable = true;
      antialias = true;
      defaultFonts = {
        sansSerif = [ "Inter" ];
        monospace = [ "Liberation Mono" ];
        emoji = [ "Noto Color Emoji" ];
        serif = [ "Roboto Slab" ];
      };
    };

    packages = with pkgs;
      [
        liberation_ttf
        inter
        jetbrains-mono
        roboto
        noto-fonts-emoji # emoji
        noto-fonts
      ];
  };

  environment.systemPackages = with pkgs;[ font-manager ];
}

