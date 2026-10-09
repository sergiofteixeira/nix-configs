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
      automation = "!include automations.yaml";
    };
  };

  services.matterjs-server = {
    enable = true;
    extraArgs = [ "--primary-interface=eno1" ];
  };
}
