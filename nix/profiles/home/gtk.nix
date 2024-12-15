# profiles/home/gtk.nix
#
# Author: João Borges <RageKnify@gmail.com>
# URL:    https://github.com/RageKnify/Config
#
# gtk configuration

{ pkgs, ... }:
{
  gtk = {
    enable = true;
    font = {
      name = "Noto";
      size = 14;
    };
    iconTheme = {
      package = pkgs.papirus-icon-theme;
      name = "Papirus-Dark";
    };
    theme = {
      package = pkgs.solarc-gtk-theme;
      name = "SolArc";
    };
  };
}
