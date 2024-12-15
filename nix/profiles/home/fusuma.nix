# profiles/home/fusuma.nix
#
# Author: João Borges <RageKnify@gmail.com>
# URL:    https://github.com/RageKnify/Config
#
# fusuma configuration

{
  pkgs,
  config,
  lib,
  ...
}:
{
  services.fusuma = {
    enable = true;
    package = pkgs.latest.fusuma;
    extraPackages = with pkgs; [
      xdotool
      i3
      coreutils
    ];
    settings = {
      threshold = {
        swipe = 0.25;
        pinch = 0.4;
      };
      interval = {
        swipe = 1.0;
        pinch = 0.1;
      };
      swipe = {
        "3" = {
          left = {
            command = "exec i3-msg focus right";
          };
          right = {
            command = "exec i3-msg focus left";
          };
          up = {
            command = "exec i3-msg focus down";
          };
          down = {
            command = "exec i3-msg focus up";
          };
        };
        "4" = {
          left = {
            command = "exec i3-msg workspace next";
          };
          right = {
            command = "exec i3-msg workspace prev";
          };
          up = {
            command = "exec i3-msg fullscreen toggle";
          };
          down = {
            command = "exec i3-msg floating toggle";
          };
        };
      };
    };
  };
}
