# modules/home/fish.nix
#
# Author: João Borges <RageKnify@gmail.com>
# URL:    https://github.com/RageKnify/Config
#
# Fish home configuration.

{ pkgs, ... }:
{
  programs.fish.enable = true;

  # starship
  programs.starship.enable = true;
  programs.fish.promptInit = ''
  starship init fish | source
  '';
}
