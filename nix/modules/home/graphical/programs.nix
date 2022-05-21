# modules/home/graphic/programs.nix
#
# Author: João Borges <RageKnify@gmail.com>
# URL:    https://github.com/RageKnify/Config
#
# Useful GUI programs

{ pkgs, lib, config, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.modules.graphical.programs;
in {
  options.modules.graphical.programs.enable = mkEnableOption "programs";

  config = mkIf cfg.enable {
    home.packages = [
      pkgs.unstable.discord
      pkgs.unstable.signal-desktop
      pkgs.thunderbird
    ];
  };
}
