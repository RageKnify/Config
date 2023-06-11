# profiles/server.nix
#
# Author: João Borges <RageKnify@gmail.com>
# URL:    https://github.com/RageKnify/Config
#
# Config for servers

{ pkgs, config, lib, sshKeys, ... }:
{
  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
    };
    authorizedKeysFiles = lib.mkForce [ "/etc/ssh/authorized_keys.d/%u" ];
  };

  users = { users = { jp.openssh.authorizedKeys.keys = sshKeys; }; };

  system.autoUpgrade = {
    enable = true;
    flake = "github:RageKnify/Config?dir=nix";
    allowReboot = true;
    rebootWindow = {
      lower = "03:00";
      upper = "05:00";
    };
  };

  nix.gc = {
    automatic = true;
    dates = "weekly";
    randomizedDelaySec = "60min";
  };
}
