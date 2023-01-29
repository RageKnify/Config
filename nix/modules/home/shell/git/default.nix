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
        commit.template = "${builtins.toString ./.}/gitmessage.txt";
        commit.verbose = true;
      };
      includes = [
        {
          condition = "gitdir:~/dev/github/";
          contents.user = {
            name = "RageKnify";
            email = "RageKnify@gmail.com";
          };
        }
        {
          condition = "gitdir:~/dev/gitlab.rnl/";
          contents.user = {
            name = "João Borges";
            email = "joao.p.l.borges@tecnico.ulisboa.pt";
          };
        }
        {
          condition = "gitdir:~/dev/ark/";
          contents.user = {
            name = "João Borges";
            email = "joao.borges@rnl.tecnico.ulisboa.pt";
          };
        }
      ];
      aliases = {
        st = "status -sv";
        ll = "log --oneline --graph --max-count=30";
        llw = "log --oneline --graph --max-count=30 --since 'last week'";
        lll = "log --oneline --graph";
      };
    };
  };
}
