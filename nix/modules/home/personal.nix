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
    home.packages = with pkgs;[
      # LaTeX
      texlive.combined.scheme-full
      texlab
      # Rust
      rustup
      pkgs.unstable.rust-analyzer
      # GCC
      pkgs.gcc
      # Make
      pkgs.gnumake
    ];
  };
}
