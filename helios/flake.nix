{
  description = "A template that shows all standard flake outputs";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    vscode-server.url = "github:nix-community/nixos-vscode-server";
  };

  outputs = all@{ self, nixpkgs, vscode-server, ... }: {

    nixosConfigurations = {
      # sudo nixos-rebuild switch --flake /path/to/flakes/directory#<name>
      "helios" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";

        modules = [
          vscode-server.nixosModules.default
          ({ config, pkgs, ... }: { services.vscode-server.enable = true; })
          ./configuration.nix
        ];
      };
    };
  };
}
