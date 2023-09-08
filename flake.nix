{
  description = "Home Servers flakes";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    vscode-server.url = "github:nix-community/nixos-vscode-server";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    agenix.url = "github:ryantm/agenix";
    nixinate.url = "github:matthewcroughan/nixinate";
  };

  outputs = { self, nixpkgs, vscode-server, home-manager, agenix, nixinate, ... }: {

    apps = nixinate.nixinate.x86_64-linux self;
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
          {
            _module.args.nixinate = {
              host = "192.168.1.81";
              sshUser = "steixeira";
              buildOn = "remote";
              substituteOnTarget = true;
              hermetic = false;
            };
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
  };
}
