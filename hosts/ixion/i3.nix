{
  pkgs,
  config,
  lib,
  ...
}:
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
      defaultSession = "gnome";
      #defaultSession = "none+i3";
    };
    desktopManager = {
      xterm.enable = false;
      gnome.enable = true;
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
        lxappearance
        xclip
      ];
    };
    xkb.layout = "us";
    xkb.variant = "";
  };
  services.clipmenu.enable = true;
  systemd.tmpfiles.rules = [
    "L+ /run/gdm/.config/monitors.xml - - - - ${pkgs.writeText "gdm-monitors.xml" ''
      <monitors version="2">
        <configuration>
          <logicalmonitor>
            <x>0</x>
            <y>0</y>
            <primary>yes</primary>
            <scale>2</scale>
            <monitor>
              <monitorspec>
                <connector>DP-1</connector>
                <vendor>APP</vendor>
                <product>StudioDisplay</product>
                <serial>0x6ca18b19</serial>
              </monitorspec>
              <mode>
                <width>5120</width>
                <height>2880</height>
                <rate>60.000</rate>
              </mode>
            </monitor>
          </logicalmonitor>
        </configuration>
      </monitors>
    ''}"
  ];
}
