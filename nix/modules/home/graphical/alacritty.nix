# modules/home/graphical/alacritty.nix
#
# Author: João Borges <RageKnify@gmail.com>
# URL:    https://github.com/RageKnify/Config
#
# alacritty configuration.

{ lib, config, colors, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.modules.graphical.alacritty;
in
{
  options.modules.graphical.alacritty.enable = mkEnableOption "alacritty";

  config = mkIf cfg.enable {
    programs.alacritty = {
      enable = true;
      settings = {
        font.size = 9;
        window = {
          padding = {
            x = 2;
            y = 2;
          };
        };
        key_bindings = [
          { key = "C"; mods = "Alt"; action = "Copy"; }
          { key = "V"; mods = "Alt"; action = "Paste"; }
        ];
        colors = with colors.light; {
            primary = {
              background = "#${base00}";
              foreground = "#${base05}";
            };

            # Colors the cursor will use if `custom_cursor_colors` is true
            cursor = {
              text   = "#${base00}";
              cursor = "#${base05}";
            };

            # Normal colors
            normal =  {
              black   = "#${base00}";
              red     = "#${base08}";
              green   = "#${base0B}";
              yellow  = "#${base0A}";
              blue    = "#${base0D}";
              magenta = "#${base0E}";
              cyan    = "#${base0C}";
              white   = "#${base05}";
            };

            # Bright colors
            bright = {
              black   = "#${base03}";
              red     = "#${base08}";
              green   = "#${base0B}";
              yellow  = "#${base0A}";
              blue    = "#${base0D}";
              magenta = "#${base0E}";
              cyan    = "#${base0C}";
              white   = "#${base07}";
            };

            indexed_colors = [
               { index = 16; color = "#${base09}"; }
               { index = 17; color = "#${base0F}"; }
               { index = 18; color = "#${base01}"; }
               { index = 19; color = "#${base02}"; }
               { index = 20; color = "#${base04}"; }
               { index = 21; color = "#${base06}"; }
            ];
        };
      };
    };
    home.sessionVariables.TERMINAL = "alacritty";
  };
}
