{ pkgs, config, ... }:
{
  services.xserver = {
    dpi = 192;
    enable = true;
    videoDrivers = [ "amdgpu" ];
    displayManager = {
      sddm = {
        enable = true;
        theme = "chili";
        settings = {
          X11 = {
            ServerArguments = "-dpi 192";
            EnableHiDPI = true;
          };
          Theme = {
            CursorTheme = "macOS-BigSur";
            CursorSize = 48;
          };
        };
      };
      defaultSession = "none+i3";
    };
    desktopManager = {
      xterm.enable = false;
    };
    windowManager.i3 = {
      enable = true;
      extraPackages = with pkgs; [
        firefox
        clipmenu
        dmenu
        i3status
        i3lock
        redshift
        xfce.thunar
        bitwarden-desktop
      ];
    };
    xkb.layout = "us";
    xkb.variant = "";
  };
  services.clipmenu.enable = true;
}
