{ pkgs, inputs, ... }:
{
  fonts = {
    enableDefaultPackages = false;

    fontconfig = {
      enable = true;

      antialias = true;

      defaultFonts = {
        monospace = [ "DejaVu Sans Mono" ];
        #sansSerif = [ "Inter" ];
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
      inputs.self.packages.${pkgs.system}.sf-mono
      #noto-fonts
      #noto-fonts-cjk
      #noto-fonts-emoji
      #ubuntu_font_family
    ];
  };
}
