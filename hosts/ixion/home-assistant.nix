{ config, pkgs, ... }:
let
  tapo-control = pkgs.fetchFromGitHub {
    owner = "JurajNyiri";
    repo = "HomeAssistant-Tapo-Control";
    tag = "7.2.13";
    hash = "sha256-YrAMqwUi9jdC/SfI13NlUz4OfTKd9Jj4mix/uwgMyu8=";
  };
  # release asset rather than the source tree, which lacks the built frontend;
  # only used to seed the first install, HACS updates itself from then on
  hacs = pkgs.fetchzip {
    url = "https://github.com/hacs/integration/releases/download/2.0.5/hacs.zip";
    stripRoot = false;
    hash = "sha256-iMomioxH7Iydy+bzJDbZxt6BX31UkCvqhXrxYFQV8Gw=";
  };
in
{
  environment.etc."hass/configuration.yaml".text = ''
    default_config:
    automation: !include automations.yaml
    frontend:
      themes: !include_dir_merge_named themes
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

  systemd.services.docker-home-assistant.preStart = ''
    mkdir -p /var/lib/hass/themes
    if [ ! -e /var/lib/hass/custom_components/hacs ]; then
      mkdir -p /var/lib/hass/custom_components
      cp -r --no-preserve=mode ${hacs} /var/lib/hass/custom_components/hacs
    fi
  '';

  services.matterjs-server = {
    enable = true;
    extraArgs = [ "--primary-interface=eno1" ];
  };
}
