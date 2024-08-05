# profiles/home/tmux.nix
#
# Author: João Borges <RageKnify@gmail.com>
# URL:    https://github.com/RageKnify/Config
#
# tmux configuration

{
  pkgs,
  config,
  lib,
  myLib,
  osConfig,
  ...
}:
let
  colors = myLib.colors;
  hostColor = myLib.hostNameToColor osConfig.networking.hostName;
in
{
  programs.tmux = {
    enable = true;
    clock24 = true;
    customPaneNavigationAndResize = true;
    escapeTime = 0;
    extraConfig = ''
      set -sa terminal-overrides ',gnome*:RGB'
      set -sa terminal-overrides ',xterm-256color:RGB'
      set -as terminal-features ",*:hyperlinks"
      # Set status bar color
      set -g status-style fg='${colors.light.base07}',bg='${hostColor}'

      # set status line
      set -g status-left '#[bold][#S]  '
      set -g status-left-length 10
      set -g status-right '#[bold]#h  '
      set -g status-right-length 10
      set -g window-status-style bold

      # New panes/windows are always opened in the current working directory
      bind '"' split-window -c "#{pane_current_path}"
      bind % split-window -h -c "#{pane_current_path}"
      bind c new-window -c "#{pane_current_path}"

      # Enable mouse
      set -g mouse on

      # Enable osc-52
      set -g set-clipboard on
    '';
    historyLimit = 50000;
    keyMode = "vi";
    terminal = "tmux-256color";
    shell = "${pkgs.fish}/bin/fish";
  };
}
