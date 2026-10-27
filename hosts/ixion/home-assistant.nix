{ config, pkgs, ... }:
let
  tapo-control = pkgs.fetchFromGitHub {
    owner = "JurajNyiri";
    repo = "HomeAssistant-Tapo-Control";
    tag = "7.2.13";
    hash = "sha256-YrAMqwUi9jdC/SfI13NlUz4OfTKd9Jj4mix/uwgMyu8=";
  };
in
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
      # custom integrations; their python requirements are installed by HA on start
      "${tapo-control}/custom_components/tapo_control:/config/custom_components/tapo_control:ro"
    ];
  };

  services.matterjs-server = {
    enable = true;
    extraArgs = [ "--primary-interface=eno1" ];
  };
}
