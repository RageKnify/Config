# modules/home/graphical/fusuma.nix
#
# Author: João Borges <RageKnify@gmail.com>
# URL:    https://github.com/RageKnify/Config
#
# Fusuma configuration.

{ pkgs, config, lib, ... }:
let
  inherit (lib) mkEnableOption mkIf mkForce;
  cfg = config.modules.graphical.fusuma;
in
{
  options.modules.graphical.fusuma.enable = mkEnableOption "fusuma";

  config = mkIf cfg.enable {
    services.fusuma = {
      enable = true;
      extraPackages = with pkgs;[ xdotool i3-gaps coreutils ];
      settings = {
        thershold = { swipe = 0.4; pinch = 0.4; };
        interval = { swipe = 0.8; pinch = 0.1; };
        swipe = {
          "3" = {
            left = { command = "exec i3-msg focus right"; };
            right = { command = "exec i3-msg focus left"; };
            up = { command = "exec i3-msg focus down"; };
            down = { command = "exec i3-msg focus up"; };
          };
          "4" = {
            left = { command = "exec i3-msg workspace next"; };
            right = { command = "exec i3-msg workspace prev"; };
            up = { command = "exec i3-msg fullscreen toggle"; };
            down = { command = "exec i3-msg floating toggle"; };
          };
        };
      };
    };
  };
}
