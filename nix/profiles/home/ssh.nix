# profiles/home/ssh.nix
#
# Author: João Borges <RageKnify@gmail.com>
# URL:    https://github.com/RageKnify/Config
#
# ssh configuration

{ config, lib, ... }:
let
  setEnv = { TERM = "xterm-256color"; };
  kerberosExtraOptions = {
    GSSAPIAuthentication = "yes";
    GSSAPIDelegateCredentials = "yes";
  };
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
      "research*" = {
        user = "fmarques";
        hostname = "mustard.stt.rnl.tecnico.ulisboa.pt";
        inherit setEnv;
      };
      "research12" = { port = 2222; };
      "research20" = { port = 2230; };
      ctf = {
        user = "stt";
        hostname = "mustard.stt.rnl.tecnico.ulisboa.pt";
        port = 2204;
        inherit setEnv;
      };
      garlic = {
        user = "stt";
        hostname = "pest.stt.rnl.tecnico.ulisboa.pt";
        inherit setEnv;
      };
      sig = {
        hostname = "sigma03.tecnico.ulisboa.pt";
        user = "ist189482";
        extraOptions = kerberosExtraOptions;
        inherit setEnv;
      };
      nex = {
        hostname = "nexus1.rnl.tecnico.ulisboa.pt";
        user = "ist189482";
        extraOptions = kerberosExtraOptions;
        inherit setEnv;
      };
      clu = {
        hostname = "cluster.rnl.tecnico.ulisboa.pt";
        user = "ist189482";
        extraOptions = kerberosExtraOptions;
        inherit setEnv;
      };
    };
  };
}
