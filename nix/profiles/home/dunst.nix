# profiles/home/dunst.nix
#
# Author: João Borges <RageKnify@gmail.com>
# URL:    https://github.com/RageKnify/Config
#
# dunst configuration

{
  pkgs,
  config,
  lib,
  myLib,
  ...
}:
{
  services.dunst = {
    enable = true;
    settings = with myLib.colors.dark; {
      global = {
        follow = "mouse";
        width = "(200, 300)";
        height = 200;
        notification_limit = 2;
        offset = "(30, 30)";
        padding = 6;
        font = "Monospace 14";
        horizontal_padding = 6;
        dmenu = "${pkgs.rofi}/bin/rofi -dmenu";
        frame_color = "${base00}";
      };
      urgency_low = {
        background = "${base01}";
        foreground = "${base05}";
      };
      urgency_normal = {
        background = "${base01}";
        foreground = "${base05}";
      };
      urgency_critical = {
        background = "${base01}";
        foreground = "${base08}";
        frame_color = "${base08}";
      };
    };
  };
}
