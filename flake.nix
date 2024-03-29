{
  description = "Home Servers flakes";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    vscode-server.url = "github:nix-community/nixos-vscode-server";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    agenix.url = "github:ryantm/agenix";
    nixinate.url = "github:matthewcroughan/nixinate";
    darwin.url = "github:lnl7/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, vscode-server, home-manager, agenix, nixinate
    , darwin, ... }: {

      apps = nixinate.nixinate.x86_64-linux self;
      nixosConfigurations = {
        helios = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";

          modules = [
            ./hosts/helios/configuration.nix
            agenix.nixosModules.default
            home-manager.nixosModules.home-manager
            {
              environment.systemPackages =
                [ agenix.packages.x86_64-linux.default ];
            }
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.steixeira = import ./users/steixeira.nix;
            }
          ];
        };

        nemesis = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";

          modules = [
            ./hosts/nemesis/configuration.nix
            agenix.nixosModules.default
            home-manager.nixosModules.home-manager
            {
              environment.systemPackages =
                [ agenix.packages.x86_64-linux.default ];
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
              environment.systemPackages =
                [ agenix.packages.x86_64-linux.default ];
            }
            ./hosts/phrike/configuration.nix
            agenix.nixosModules.default
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.steixeira = import ./users/steixeira.nix;
            }
            {
              _module.args.nixinate = {
                host = "192.168.1.80";
                sshUser = "steixeira";
                buildOn = "remote";
                substituteOnTarget = true;
                hermetic = false;
              };
            }
          ];
        };

      };

      # darwin configs
      darwinConfigurations = {
        m1pro = darwin.lib.darwinSystem {
          system = "aarch64-darwin";
          pkgs = import nixpkgs { system = "aarch64-darwin"; };
          modules = [
            ./hosts/m1pro/darwin.nix
            home-manager.darwinModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                users.steixeira.imports = [ ./shared/darwin/shared.nix ];
              };
              users.users.steixeira.home = "/Users/steixeira";
            }
          ];
        };

        m1work = darwin.lib.darwinSystem {
          system = "aarch64-darwin";
          pkgs = import nixpkgs { system = "aarch64-darwin"; };
          modules = [
            agenix.nixosModules.default
            ./hosts/m1work/darwin.nix
            home-manager.darwinModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                users.steixeira.imports = [ ./shared/darwin/shared.nix ];
              };
              users.users.steixeira.home = "/Users/steixeira";
            }
          ];
        };
      };

    };
}
