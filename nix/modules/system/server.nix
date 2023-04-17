# modules/system/server.nix
#
# Author: João Borges <RageKnify@gmail.com>
# URL:    https://github.com/RageKnify/Config
#
# Config for servers

{ pkgs, config, lib, sshKeys, ... }:
let
  inherit (lib) mkEnableOption mkOption types mkIf;
  cfg = config.modules.server;
in
{
  options.modules.server = {
    enable = mkEnableOption "server";
  };

  config = mkIf cfg.enable {
    services.openssh = {
      enable = true;
      passwordAuthentication = false;
      permitRootLogin = "no";
      authorizedKeysFiles = lib.mkForce [ "/etc/ssh/authorized_keys.d/%u" ];
      kbdInteractiveAuthentication = false;
    };

    users = {
      users = {
        jp.openssh.authorizedKeys.keys = sshKeys;
      };
    };

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
  };
}
