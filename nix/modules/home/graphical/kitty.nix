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
      # wait for 22.05? -> theme = "Solarized Light";
      settings = with colors.light; {
        background = "${base00}";
        foreground = "${base05}";
        selection_background = "${base05}";
        selection_foreground = "${base00}";
        url_color = "${base04}";
        cursor = "${base05}";
        active_border_color = "${base03}";
        inactive_border_color = "${base01}";
        active_tab_background = "${base00}";
        active_tab_foreground = "${base05}";
        inactive_tab_background = "${base01}";
        inactive_tab_foreground = "${base04}";

        # normal
        color0 = "${base07}";
        color1 = "${base08}";
        color2 = "${base0B}";
        color3 = "${base0A}";
        color4 = "${base0D}";
        color5 = "${base0E}";
        color6 = "${base0C}";
        color7 = "${base02}";

        # bright
        color8 = "${base04}";
        color9 = "${base09}";
        color10 = "${base06}";
        color11 = "${base05}";
        color12 = "${base03}";
        color13 = "${base01}";
        color14 = "${base0F}";
        color15 = "${base00}";
      };
    };
    xsession.windowManager.i3.config.terminal = "kitty";
    home.sessionVariables.TERMINAL = "kitty";
  };
}
