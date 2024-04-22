{ pkgs, ... }:
{
  services.xserver = {
    enable = true;
    videoDrivers = [ "amdgpu" ];
    displayManager = {
      gdm = {
        enable = true;
        wayland = true;
      };
      defaultSession = "gnome";
    };
    desktopManager = {
      xterm.enable = false;
      gnome.enable = true;
    };
    xkb.layout = "us";
    xkb.variant = "";
  };
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
