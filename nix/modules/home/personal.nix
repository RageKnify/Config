# modules/home/personal.nix
#
# Author: João Borges <RageKnify@gmail.com>
# URL:    https://github.com/RageKnify/Config
#
# personal home configuration, activates if system module is active

{ pkgs, lib, osConfig, profiles, ... }:
let
  personal = osConfig.modules.personal;
  inherit (lib) lists;
in {
  home.packages = with pkgs;
    lists.optionals personal.enable [
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
}
