# modules/home/shell/git.nix
#
# Author: João Borges <RageKnify@gmail.com>
# URL:    https://github.com/RageKnify/Config
#
# Git configuration. (Based on RiscadoA's)

{
  pkgs,
  lib,
  options,
  config,
  ...
}:
let
  inherit (lib)
    mkDefault
    mkOption
    mkEnableOption
    mkIf
    types
    generators
    ;
  cfg = config.modules.git;
  signers = builtins.toFile "signers" ''
    RageKnify@gmail.com,joao.p.l.borges@tecnico.ulisboa.pt,joao.borges@rnl.tecnico.ulisboa.pt ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIC2sdJFvvnEIYztPcznXvKpY4vOWedZ1qzDaAgRxrczS jp@war
  '';
in
{
  options.modules.git = {
    enable = mkEnableOption "git";

    includes = options.programs.git.includes;
  };

  config = mkIf cfg.enable {
    programs.delta = {
        enable = true;
        options = {
          light = true;
        };
    };
    programs.git = {
      enable = true;
      settings = {
        diff.tool = "vimdiff";
        init.defaultBranch = "main";
        pull.rebase = true;
        url."git@github.com".pushinsteadOf = "https://github.com/";
        commit = {
          template = pkgs.copyPathToStore ./gitmessage.txt;
          verbose = true;
          gpgSign = true;
        };
        gpg.format = "ssh";
        gpg.ssh.allowedSignersFile = signers;
        user.signingKey = "~/.ssh/id_ed25519";
        aliases = {
          ca = "commit --amend";
          st = "status -sv";
          sts = "status";
          p = "push";
          pu = "push -u origin @";
          pf = "push --force-with-lease";
          ll = "log --oneline --graph --max-count=30";
          llw = "log --oneline --graph --max-count=30 --since 'last week'";
          lll = "log --oneline --graph";
        };
      };
      includes = cfg.includes;
    };
  };
}
