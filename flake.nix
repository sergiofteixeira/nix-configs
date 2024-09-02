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
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      agenix,
      darwin,
      disko,
      ...
    }@inputs:
    {

      nixosConfigurations = {

        phrike = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = {
            inherit inputs;
          };

          modules = [
            { _module.args = inputs; }
            { environment.systemPackages = [ agenix.packages.x86_64-linux.default ]; }
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
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                users.steixeira.imports = [ ./users/steixeira.nix ];
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
            agenix.nixosModules.default
            ./modules/darwin/homebrew.nix
            ./modules/darwin/defaults.nix
            home-manager.darwinModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                users.steixeira.imports = [ ./users/steixeira.nix ];
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
