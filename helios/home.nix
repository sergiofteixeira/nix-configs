{ config, pkgs, ... }:

{
  home.username = "steixeira";
  home.homeDirectory = "/home/steixeira";
  home.stateVersion = "23.05";
  programs.home-manager.enable = true;
}
