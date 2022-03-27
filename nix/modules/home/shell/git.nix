# modules/home/shell/git.nix
#
# Author: João Borges <RageKnify@gmail.com>
# URL:    https://github.com/RageKnify/Config
#
# Git configuration. (Based on RiscadoA's)

{ lib, config, configDir, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.modules.shell.git;
in {
  options.modules.shell.git.enable = mkEnableOption "git";

  config = mkIf cfg.enable {
    programs.git = {
      enable = true;
      extraConfig = {
        diff.tool = "vimdiff";
        init.defaultBranch = "main";
        pull.rebase = true;
        url."git@github.com".pushinsteadOf = "https://github.com/";
        commit.template = "${configDir}/gitmessage.txt" ;
      };
      aliases = {
        st = "status";
      };
    };
  };
}
