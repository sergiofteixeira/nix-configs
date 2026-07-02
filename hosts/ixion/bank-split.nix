{ config, lib, ... }:
let
  secretNames = [
    "bank_split_google_client_id"
    "bank_split_google_client_secret"
    "bank_split_auth_secret"
  ];
in
{
  age.secrets = lib.genAttrs secretNames (name: {
    file = ../../secrets/${name}.age;
  });

  virtualisation.oci-containers.containers = {
    bank-split-postgres = {
      image = "postgres:16";
      extraOptions = [ "--network=host" ];
      environment = {
        POSTGRES_USER = "bank_split";
        POSTGRES_PASSWORD = "bank_split_password";
        POSTGRES_DB = "bank_split";
      };
      volumes = [ "bank-split-postgres:/var/lib/postgresql/data" ];
    };

    bank-split = {
      image = "sergiofpteixeira/bank-split:latest";
      dependsOn = [ "bank-split-postgres" ];
      extraOptions = [ "--network=host" ];
      environmentFiles = map (n: config.age.secrets.${n}.path) secretNames;
      environment = {
        DATABASE_URL = "postgresql://bank_split:bank_split_password@localhost:5432/bank_split?schema=public";
        NEXTAUTH_URL = "https://bank-split.temporalreach.cloud";
      };
    };
  };
}
