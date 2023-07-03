# hosts/war/home.nix
#
# Author: João Borges <RageKnify@gmail.com>
# URL:    https://github.com/RageKnify/Config
#
# Home configuration.

{ pkgs, ... }: {
  modules = {
    neovim.enable = true;
    xdg.enable = true;
    graphical.i3.enable = true;
    graphical.sxhkd.enable = true;
    graphical.kitty.enable = true;
    graphical.gtk.enable = true;
    graphical.fusuma.enable = true;
    graphical.programs.enable = true;
    personal.enable = true;
    shell.git.enable = true;
    shell.tmux.enable = true;
  };

  home.packages = with pkgs; [ ];

  home.keyboard = null;
  home.stateVersion = "21.11";
}
