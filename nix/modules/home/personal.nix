# modules/home/personal.nix
#
# Author: João Borges <RageKnify@gmail.com>
# URL:    https://github.com/RageKnify/Config
#
# personal home configuration.

{ pkgs, lib, config, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.modules.personal;
in {
  options.modules.personal.enable = mkEnableOption "personal";

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      # ansible
      ansible
      # agenix
      agenix
      # calc
      libqalculate
      # wallpaper script
      horseman_wallpaper
      # LaTeX
      texlive.combined.scheme-full
      texlab
      # Rust
      rustup
      # GCC
      gcc
      # Make
      gnumake
      # Python
      my_python
      # nixfmt
      nixfmt
    ];
  };
}
