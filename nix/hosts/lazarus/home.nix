# hosts/lazarus/home.nix
#
# Author: João Borges <RageKnify@gmail.com>
# URL:    https://github.com/RageKnify/Config
#
# Home configuration.

{ pkgs, ... }:
{
  modules = {
    fish.enable = true;
    neovim.enable = true;
  };

  home.stateVersion = "21.11";
}
