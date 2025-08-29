# modules/home/personal.nix
#
# Author: João Borges <RageKnify@gmail.com>
# URL:    https://github.com/RageKnify/Config
#
# personal home configuration, activates if system module is active

{
  pkgs,
  lib,
  osConfig,
  ...
}:
let
  personal = osConfig.modules.personal;
in
lib.attrsets.optionalAttrs personal.enable {
  home.packages = with pkgs; [
    # agenix
    agenix
    # calc
    libqalculate
    # wallpaper script
    horseman_wallpaper
    # Rust
    rustup
    # GCC
    gcc
    # Make
    gnumake
    # Python
    my_python
    # Scheme
    chez
    # typst
    typst
    typstfmt
    # nixfmt
    nixfmt-rfc-style
    # node
    nodejs_24
    typescript-language-server
  ];
}
