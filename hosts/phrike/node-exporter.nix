{ ... }:

{
  services.prometheus = {
    exporters = {
      node = {
        openFirewall = true;
        enable = true;
        enabledCollectors = [ "systemd" ];
      };
    };
  };
}
