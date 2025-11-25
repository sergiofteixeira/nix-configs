{ config, ... }:

{
  age.secrets.beszel_agent_keyfile = {
    file = ../../secrets/beszel_helios_key.age;
  };
  services.tailscale.enable = true;
  systemd.services.tailscale-autoconnect = {
    description = "Automatic connection to Tailscale";

    after = [
      "network-pre.target"
      "tailscale.service"
    ];
    wants = [
      "network-pre.target"
      "tailscale.service"
    ];
    wantedBy = [ "multi-user.target" ];

    serviceConfig.Type = "oneshot";
  };
  services.beszel = {
    hub.enable = true;
    hub.host = "0.0.0.0";
    agent.enable = true;
    agent.environmentFile = config.age.secrets.beszel_agent_keyfile.path;
  };
}
