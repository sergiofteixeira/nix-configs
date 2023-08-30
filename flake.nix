{
  description = "Home Servers flakes";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    vscode-server.url = "github:nix-community/nixos-vscode-server";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    deploy-rs.url = "github:serokell/deploy-rs";
  };

  outputs = all@{ self, nixpkgs, vscode-server, home-manager, deploy-rs, ... }: {

    nixosConfigurations = {
      # sudo nixos-rebuild switch --flake /path/to/flakes/directory#<name>
      helios = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";

        modules = [
          vscode-server.nixosModules.default
          ({ config, pkgs, ... }: { services.vscode-server.enable = true; })
          ./helios/configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.steixeira = import ./helios/home.nix;
          }
        ];
      };

      phrike = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";

        modules = [
          vscode-server.nixosModules.default
          ({ config, pkgs, ... }: { services.vscode-server.enable = true; })
          ./phrike/configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            #home-manager.users.steixeira = import ./helios/home.nix;
          }
        ];
      };
    };
    deploy.nodes = {
      phrike = {
        hostname = "192.168.1.80";
        profiles = {
          system = {
            sshUser = "steixeira";
            user = "root";
            path = deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.phrike;
          };
        };
      };
      helios = {
        hostname = "192.168.1.81";
        profiles = {
          system = {
            sshUser = "steixeira";
            user = "root";
            path = deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.helios;
          };
        };
      };
    };
    checks = builtins.mapAttrs (system: deployLib: deployLib.deployChecks self.deploy) deploy-rs.lib;
  };
}
