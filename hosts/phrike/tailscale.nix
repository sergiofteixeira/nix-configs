{ config, pkgs, ... }:

{
  services.tailscale.enable = true;
  systemd.services.tailscale-autoconnect = {
    description = "Automatic connection to Tailscale";

    # make sure tailscale is running before trying to connect to tailscale
    after = [ "network-pre.target" "tailscale.service" ];
    wants = [ "network-pre.target" "tailscale.service" ];
    wantedBy = [ "multi-user.target" ];

    # set this service as a oneshot job
    serviceConfig.Type = "oneshot";

    # have the job run this shell script
    age.secrets = {
      tailscale = {
        file = ../secrets/tailscale_key.age;
      };
    };
    script = with pkgs; ''
      # wait for tailscaled to settle
      sleep 2

      # check if we are already authenticated to tailscale
      status="$(${tailscale}/bin/tailscale status -json | ${jq}/bin/jq -r .BackendState)"
      if [ $status = "Running" ]; then # if so, then do nothing
        exit 0
      fi

      secret=$(cat "${config.age.secrets.tailscale.path}")
      # otherwise authenticate with tailscale
      ${tailscale}/bin/tailscale up -authkey $secret --advertise-exit-node --advertise-routes=192.168.1.80/32,192.168.1.81/32 --reset
    '';
  };
}
