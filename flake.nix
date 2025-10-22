{
  description = "Home Servers flakes";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    agenix.url = "github:ryantm/agenix";
    darwin.url = "github:lnl7/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs";
    disko = {
      url = "github:nix-community/disko";
    };
    disko.inputs.nixpkgs.follows = "nixpkgs";
    vscode-server.url = "github:nix-community/nixos-vscode-server";
    vscode-server.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      vscode-server,
      agenix,
      darwin,
      disko,
      ...
    }@inputs:
    {

      nixosConfigurations = {
        helios = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = {
            inherit inputs;
          };

          modules = [
            { _module.args = inputs; }
            disko.nixosModules.disko
            { environment.systemPackages = [ agenix.packages.x86_64-linux.default ]; }
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

      };

      # darwin configs
      darwinConfigurations = {
        m1pro = darwin.lib.darwinSystem {
          system = "aarch64-darwin";
          pkgs = import nixpkgs { system = "aarch64-darwin"; };
          modules = [
            ./modules/darwin/homebrew.nix
            ./modules/darwin/defaults.nix
            home-manager.darwinModules.home-manager
            agenix.darwinModules.default
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                users.steixeira.imports = [ ./users/steixeira.nix ];
                sharedModules = [ agenix.homeManagerModules.default ];
              };
              users.users.steixeira.home = "/Users/steixeira";
              system.stateVersion = 4;
              networking = {
                hostName = "TARS";
              };
            }
          ];
        };

        m1work = darwin.lib.darwinSystem {
          system = "aarch64-darwin";
          pkgs = import nixpkgs { system = "aarch64-darwin"; };
          modules = [
            ./modules/darwin/homebrew.nix
            ./modules/darwin/defaults.nix
            home-manager.darwinModules.home-manager
            agenix.darwinModules.default
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                users.steixeira.imports = [ ./users/steixeira.nix ];
                sharedModules = [ agenix.homeManagerModules.default ];
              };
              users.users.steixeira.home = "/Users/steixeira";
              system.stateVersion = 4;
              networking = {
                hostName = "CASE";
              };
            }
          ];
        };
      };
    };
}
