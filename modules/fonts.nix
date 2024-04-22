{ pkgs, ... }:
{
  fonts = {
    enableDefaultPackages = false;

    fontconfig = {
      enable = true;

      antialias = true;

      defaultFonts = {
        monospace = [ "Liga SFMono Nerd Font" ];
        sansSerif = [ "Tex Gyre Heros" ];
        serif = [ "Libertinus Serif" ];
      };

      hinting = {
        enable = true;
        autohint = false;
        style = "full";
      };

      subpixel = {
        lcdfilter = "default";
        rgba = "rgb";
      };
    };

    fontDir = {
      enable = true;
      decompressFonts = true;
    };

    packages = with pkgs; [
      libertinus
      gyre-fonts
      dejavu_fonts
      hack-font
      inter
      sf-mono-liga-bin
      ubuntu_font_family
      nerdfonts
    ];
  };
}
