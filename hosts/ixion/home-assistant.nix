{ ... }:

{
  services.home-assistant = {
    enable = true;
    openFirewall = true;
    extraComponents = [
      "apple_tv"
      "bluetooth"
      "spotify"
      "jellyfin"
      "ipma"
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
}
