# hosts/war/home.nix
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
    xdg.enable = true;
    graphical.i3.enable = true;
    graphical.sxhkd.enable = true;
    graphical.alacritty.enable = true;
    shell.git.enable = true;
  };

  home.packages = [
    pkgs.unstable.discord
    pkgs.thunderbird
  ];

  home.keyboard = null;
  home.stateVersion = "21.11";
}
