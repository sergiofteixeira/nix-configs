{ config, pkgs, ... }:

{
  nixpkgs.overlays = [ (import ../../overlays/loki.nix) ];

  # Configure Loki service
  services.loki = {
    enable = true;
    package = pkgs.grafana-loki;
  };
}
