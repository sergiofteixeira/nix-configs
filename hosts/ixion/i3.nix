{ pkgs, ... }:
{
  #systemd.services.gnome-randr = {
  #enable = true;
  #description = "gnome-randr";
  #unitConfig = {
  #Type = "simple";
  #};
  #serviceConfig = {
  #Environment = "DISPLAY=:0";
  #ExecStart = "${pkgs.gnome-randr}/bin/gnome-randr modify 'DP-1' --mode '5120x2880@60.000'";
  #ExecStartPre = "${pkgs.coreutils}/bin/sleep 2";
  #};
  #after = [ "display-manager.service" ];
  #wantedBy = [ "multi-user.target" ];
  #};

  services.xserver = {
    #dpi = 192;
    enable = true;
    videoDrivers = [ "amdgpu" ];
    displayManager = {
      gdm = {
        enable = true;
        wayland = true;
      };
      #sddm = {
      #enable = true;
      #theme = "chili";
      #settings = {
      #X11 = {
      #ServerArguments = "-dpi 192";
      #EnableHiDPI = true;
      #};
      #Theme = {
      #CursorTheme = "macOS-BigSur";
      #CursorSize = 48;
      #};
      #};
      #};
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
        way-displays
        meson
        gnome-randr
        gnome.gnome-tweaks
        gnome.gnome-shell-extensions
        gnomeExtensions.user-themes
        gnomeExtensions.tailscale-status
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
