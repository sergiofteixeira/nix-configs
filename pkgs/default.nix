{
  systems = [ "x86_64-linux" ];

  perSystem =
    { pkgs, ... }:
    {
      packages = {
        sf-mono = pkgs.callPackage ./sf-mono { inherit (pkgs) stdenv; };
      };
    };
}
