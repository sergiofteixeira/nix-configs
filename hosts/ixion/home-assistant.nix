{ config, ... }:

{
  environment.etc."hass/configuration.yaml".text = ''
    default_config:
    automation: !include automations.yaml
    homeassistant:
      time_zone: ${config.time.timeZone}
  '';

  virtualisation.oci-containers.containers.home-assistant = {
    image = "ghcr.io/home-assistant/home-assistant:stable";
    pull = "always";
    extraOptions = [ "--network=host" ];
    capabilities = {
      NET_ADMIN = true;
      NET_RAW = true;
    };
    environment.TZ = config.time.timeZone;
    volumes = [
      "/var/lib/hass:/config"
      "/etc/hass/configuration.yaml:/config/configuration.yaml:ro"
      "/run/dbus:/run/dbus:ro"
    ];
  };

  services.matterjs-server = {
    enable = true;
    extraArgs = [ "--primary-interface=eno1" ];
  };
}
