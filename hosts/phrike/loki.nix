{ pkgs, config, ... }:
let
  headscale = pkgs.headscale.override {
    buildGoModule =
      args:
      pkgs.buildGoModule (
        args
        // rec {
          version = "0.23.0-alpha5";
          src = pkgs.fetchFromGitHub {
            owner = "juanfont";
            repo = "headscale";
            rev = "v${version}";
            hash = "sha256-BMrbYvxNAUs5vK7zCevSKDnB2npWZQpAtxoePXi5r40=";
          };
          vendorHash = "sha256-Yb5WaN0abPLZ4mPnuJGZoj6EMfoZjaZZ0f344KWva3o=";
        }
      );
  };
in

{
  environment.systemPackages = [ headscale ];
}
