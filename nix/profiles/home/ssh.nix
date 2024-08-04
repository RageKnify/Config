# profiles/home/ssh.nix
#
# Author: João Borges <RageKnify@gmail.com>
# URL:    https://github.com/RageKnify/Config
#
# ssh configuration

{ config, lib, ... }:
let
  setEnv = { TERM = "xterm-256color"; };
in {
  programs.ssh = {
    enable = true;

    extraConfig = ''
      IdentityFile ~/.ssh/id_ed25519
      AddKeysToAgent yes
    '';

    matchBlocks = {
      azazel = {
        hostname = "v2202306202437232333.happysrv.de";
        inherit setEnv;
      };
      b-azazel = {
        user = "root";
        hostname = "v2202306202437232333.happysrv.de";
        port = 2222;
        inherit setEnv;
      };
      conquest = {
        hostname = "conquest.bible.jborges.eu";
        inherit setEnv;
      };
      sig = {
        hostname = "sigma03.tecnico.ulisboa.pt";
        user = "ist189482";
        inherit setEnv;
      };
      nex = {
        hostname = "nexus1.rnl.tecnico.ulisboa.pt";
        user = "ist189482";
        inherit setEnv;
      };
      clu = {
        hostname = "cluster.rnl.tecnico.ulisboa.pt";
        user = "ist189482";
        inherit setEnv;
      };
      re2 = {
        user = "root";
        hostname = "10.11.99.1";
        inherit setEnv;
      };
    };
  };
}
