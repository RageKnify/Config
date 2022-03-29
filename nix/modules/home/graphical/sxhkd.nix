# modules/home/graphical/sxhkd.nix
#
# Author: João Borges <RageKnify@gmail.com>
# URL:    https://github.com/RageKnify/Config
#
# sxhkd configuration.

{ pkgs, config, lib, colors, configDir, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.modules.graphical.sxhkd;
  sxhkdMod = "mod4";
in
{
  options.modules.graphical.sxhkd.enable = mkEnableOption "sxhkd";

  config = mkIf cfg.enable {
    xsession.windowManager.i3.config.startup = [
        { command = "sxhkd"; notification = false; }
    ];
    services.sxhkd = {
      enable = true;
      keybindings = {
        # lock screen
        "${sxhkdMod} + x"     = "xscreensaver-command -lock";
        # shutdown prompt
        "${sxhkdMod}+shift+x" = "echo"; # TODO

        # flameshot
        "${sxhkdMod}+Print"    = "flameshot gui";

        # TODO: only have these for laptops
        # sound toggle
        "XF86AudioMute" = "pactl set-sink-mute @DEFAULT_SINK@ toggle";

        # volume up
        "XF86AudioRaiseVolume" = "pactl set-sink-volume @DEFAULT_SINK@ +5%";

        # volume down
        "XF86AudioLowerVolume" = "pactl set-sink-volume @DEFAULT_SINK@ -5%";

        # mic toggle
        "XF86AudioMicMute" = "pactl set-source-mute 0 toggle";

        # FIXME: these assume programs.light.enable in system
        # brightness up
        "XF86MonBrightnessUp" = "light -A 10";

        # brightness down
        "XF86MonBrightnessDown" = "light -U 10";
      };
    };
    services.flameshot = {
      enable = true;
      settings = {
      };
    };
    # for access to pactl
    home.packages = [
      pkgs.pulseaudio
    ];
  };
}
