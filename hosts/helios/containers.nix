{ config, ... }:

{
  age.secrets.tapo_secrets = {
    file = ../../secrets/tapo_secrets.age;
  };

  environment.etc."tapo/config.json".text = builtins.toJSON {
    smart_plugs = [
      {
        name = "Living Room";
        host = "10.200.0.172";
      }
      {
        name = "Office Desk";
        host = "10.200.0.123";
      }
    ];
  };

  config.virtualisation.oci-containers.containers = {

    flaresolverr = {
      image = "flaresolverr/flaresolverr:latest";
      ports = [ "8191:8191" ];
    };

    tapo-exporter = {
      autoStart = true;
      image = "tess1o/go-tapo-exporter:latest";

      volumes = [
        "/etc/tapo/config.json:/app/config.json"
      ];

      environmentFiles = [ config.age.secrets.tapo_secrets.path ];
      environment = {
        TAPO_CONFIG_LOCATION = "";
      };
    };
  };
}
