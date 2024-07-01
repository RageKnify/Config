# profiles/server/sshd.nix
#
# Author: João Borges <RageKnify@gmail.com>
# URL:    https://github.com/RageKnify/Config
#
# sshd config

{ lib, sshKeys, ... }: {
  services.openssh = {
    enable = true;
    settings = {
      # PermitRootLogin = "no";
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      LoginGraceTime = 0;
    };
    authorizedKeysFiles = lib.mkForce [ "/etc/ssh/authorized_keys.d/%u" ];
  };

  users = {
    users = {
      jp.openssh.authorizedKeys.keys = sshKeys;
      root.openssh.authorizedKeys.keys = sshKeys;
    };
  };
}
