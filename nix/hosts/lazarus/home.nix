# hosts/lazarus/home.nix
#
# Author: João Borges <RageKnify@gmail.com>
# URL:    https://github.com/RageKnify/Config
#
# Home configuration.

{ pkgs, ... }: {
  modules = { neovim.enable = true; };

  home.stateVersion = "21.11";
}
