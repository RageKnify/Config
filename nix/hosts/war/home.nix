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
    graphical.kitty.enable = true;
    graphical.gtk.enable = true;
    graphical.programs.enable = true;
    shell.git.enable = true;
  };

  # to enable starhip in nix-shells
  programs.bash.enable = true;

  home.keyboard = null;
  home.stateVersion = "21.11";
}
