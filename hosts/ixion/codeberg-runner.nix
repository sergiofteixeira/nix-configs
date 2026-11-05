{ config, lib, ... }:
let
  # file holding only the runner token from codeberg's "create new runner"
  tokenFile = ../../secrets/codeberg_runner_token.age;
in
# stays off until the token secret has been created
lib.mkIf (builtins.pathExists tokenFile) {
  age.secrets.codeberg_runner_token = {
    file = tokenFile;
  };

  services.forgejo-runner.instances.codeberg = {
    enable = true;
    settings = {
      server.connections.default = {
        url = "https://codeberg.org/";
        uuid = "a61e568f-c113-4e6d-ba50-b84b4cccc054";
      };
      runner = {
        capacity = 2;
        labels = [
          "docker:docker://node:22-bookworm"
          "ubuntu-latest:docker://ghcr.io/catthehacker/ubuntu:act-24.04"
          "nix:docker://nixos/nix:latest"
        ];
      };
      container.network = "bridge";
    };
    secrets.server.connections.default.token_url = config.age.secrets.codeberg_runner_token.path;
  };
}
