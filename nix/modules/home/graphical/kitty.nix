# modules/home/graphical/kitty.nix
#
# Author: João Borges <RageKnify@gmail.com>
# URL:    https://github.com/RageKnify/Config
#
# kitty configuration.

{ lib, config, colors, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.modules.graphical.kitty;
in {
  options.modules.graphical.kitty.enable = mkEnableOption "kitty";

  config = mkIf cfg.enable {
    programs.kitty = {
      enable = true;
      font = {
        name = "JetBrains Mono Nerd Font";
        size = 16;
      };
      keybindings = {
        "alt+c" = "copy_to_clipboard";
        "alt+v" = "paste_from_clipboard";
        "ctrl+plus" = "change_font_size all +2.0";
        "ctrl+minus" = "change_font_size all -2.0";
        "ctrl+home" = "change_font_size all 0";
      };
      theme = "Solarized Light";
    };
    xsession.windowManager.i3.config.terminal = "kitty";
    home.sessionVariables.TERMINAL = "kitty";
  };
}
