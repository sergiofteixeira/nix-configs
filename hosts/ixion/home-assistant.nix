{ ... }:

{
  services.home-assistant = {
    enable = true;
    extraComponents = [
      "apple_tv"
      "bluetooth"
      "spotify"
      "jellyfin"
      "ipma"
      "matter"
      "tplink"
      "wake_on_lan"
      "mobile_app"
    ];
    config = {
      default_config = { };
      http = {
        server_host = "0.0.0.0";
        trusted_proxies = [ "127.0.0.1" ];
        use_x_forwarded_for = true;
      };
      automation = "!include automations.yaml";
    };
  };

  # Matter controller behind the `matter` integration (ws://localhost:5580/ws).
  # This is the matter.js rewrite; python-matter-server is EOL at 8.1.2.
  services.matterjs-server = {
    enable = true;
    # eno1 is the LAN interface holding the ULA the Matter fabric runs over;
    # without this it can autodetect docker0 or tailscale0 instead.
    extraArgs = [ "--primary-interface=eno1" ];
  };
}
