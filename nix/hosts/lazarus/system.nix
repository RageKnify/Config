# hosts/lazarus/system.nix
#
# Author: João Borges <RageKnify@gmail.com>
# URL:    https://github.com/RageKnify/Config
#
# System configuration.

{ pkgs, lib, sshKeys, ... }: {
  imports = [
  ];

  boot.cleanTmpDir = true;
  networking.domain = "jplborges.pt";
  services.openssh = {
    enable = true;
    passwordAuthentication = false;
    # permitRootLogin = "no";
    authorizedKeysFiles = lib.mkForce [ "/etc/ssh/authorized_keys.d/%u" ];
    challengeResponseAuthentication = false;
  };

  users = {
    mutableUsers = true;
    users = {
      root.openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIC2sdJFvvnEIYztPcznXvKpY4vOWedZ1qzDaAgRxrczS jp@war"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAII9ckbhT0em/dL75+RV+sdqwbprRC9Ff/MoqqpBgbUSh jp@pestilence"
      ];
      jp.openssh.authorizedKeys.keys = sshKeys;
    };
  };
}
