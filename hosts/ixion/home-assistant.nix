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

  # Matter controller that the `matter` integration talks to over
  # ws://localhost:5580/ws. Ordered before home-assistant.service by the module.
  services.matter-server.enable = true;

  # The Matter SDK does its DNS-SD through Avahi over D-Bus, so the daemon has
  # to be running and allowed to publish or commissioning never finds anything.
  services.avahi = {
    enable = true;
    publish.enable = true;
    publish.addresses = true;
  };
}
