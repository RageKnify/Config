# hosts/lazarus/home.nix
#
# Author: João Borges <RageKnify@gmail.com>
# URL:    https://github.com/RageKnify/Config
#
# Home configuration.

{ pkgs, ... }:
{
  imports = [
    ../../modules/home/nvim.nix
    ../../modules/home/fish.nix
  ];

  home.stateVersion = "21.11";
}
