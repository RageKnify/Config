# modules/home/graphical/gtk.nix
#
# Author: João Borges <RageKnify@gmail.com>
# URL:    https://github.com/RageKnify/Config
#
# gtk configuration.

{ pkgs, config, lib, ... }:
let
  inherit (lib) mkEnableOption mkIf mkForce;
  cfg = config.modules.graphical.gtk;
in
{
  options.modules.graphical.gtk.enable = mkEnableOption "gtk";

  config = mkIf cfg.enable {
    gtk.enable = true;
    gtk = {
      font = {
        name = "Noto";
        size = 9;
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
  };
}
