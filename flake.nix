{
  description = "Home Servers flakes";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    vscode-server.url = "github:nix-community/nixos-vscode-server";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    deploy-rs.url = "github:serokell/deploy-rs";
    agenix.url = "github:ryantm/agenix";
    darwin.url = "github:lnl7/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, vscode-server, home-manager, deploy-rs, agenix, darwin, ... }: {

    darwinConfigurations.m1pro = darwin.lib.darwinSystem {
      system = "aarch64-darwin";
      pkgs = import nixpkgs { system = "aarch64-darwin"; };
      modules = [
        ./hosts/m1pro/darwin.nix
        home-manager.darwinModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            users.steixeira.imports = [ ./hosts/m1pro/home.nix];
          };
        }
      ];
    };


    nixosConfigurations = {
      # sudo nixos-rebuild switch --flake /path/to/flakes/directory#<name>
      helios = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";


        modules = [
          vscode-server.nixosModules.default
          ({ config, pkgs, ... }: { services.vscode-server.enable = true; })
          ./hosts/helios/configuration.nix
          agenix.nixosModules.default
          home-manager.nixosModules.home-manager
          {
            environment.systemPackages = [ agenix.packages.x86_64-linux.default ];
          }
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.steixeira = import ./users/steixeira.nix;
          }
        ];
      };

      phrike = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";

        modules = [
          vscode-server.nixosModules.default
          {
            environment.systemPackages = [ agenix.packages.x86_64-linux.default ];
          }
          ({ config, pkgs, ... }: { services.vscode-server.enable = true; })
          ./hosts/phrike/configuration.nix
          agenix.nixosModules.default
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.steixeira = import ./users/steixeira.nix;
          }
        ];
      };

      vm = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";

        modules = [
          ./hosts/vm/configuration.nix
          {
            environment.systemPackages = [ agenix.packages.x86_64-linux.default ];
          }
          agenix.nixosModules.default
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.steixeira = import ./users/steixeira.nix;
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

      vm = {
        hostname = "192.168.30.88";
        profiles = {
          system = {
            sshUser = "steixeira";
            user = "root";
            path = deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.vm;
          };
        };
      };
    };
    checks = builtins.mapAttrs (system: deployLib: deployLib.deployChecks self.deploy) deploy-rs.lib;
  };
}
