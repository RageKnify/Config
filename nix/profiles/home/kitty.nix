# profiles/home/kitty.nix
#
# Author: João Borges <RageKnify@gmail.com>
# URL:    https://github.com/RageKnify/Config
#
# kitty configuration

{ lib, config, colors, ... }:
let
  inherit (lib) mkDefault;
in{
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
  xsession.windowManager.i3.config.terminal = mkDefault "kitty";
  home.sessionVariables.TERMINAL = mkDefault "kitty";
}
