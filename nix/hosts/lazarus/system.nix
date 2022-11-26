# hosts/lazarus/system.nix
#
# Author: João Borges <RageKnify@gmail.com>
# URL:    https://github.com/RageKnify/Config
#
# System configuration.

{ pkgs, lib, sshKeys, ... }: {

  boot.cleanTmpDir = true;
  networking.domain = "jplborges.pt";
  networking.firewall.allowedTCPPorts = [ 80 443 1001 ];
  services.openssh = {
    enable = true;
    passwordAuthentication = false;
    authorizedKeysFiles = lib.mkForce [ "/etc/ssh/authorized_keys.d/%u" ];
    kbdInteractiveAuthentication = false;
  };

  users = {
    mutableUsers = true;
    users = {
      jp.openssh.authorizedKeys.keys = sshKeys;
    };
  };

  virtualisation.docker = {
    enable = true;
  };

  services.restic.backups = {
    default = {
      paths = [
        "/home/jp/caddy/static/"
        "/home/jp/data/caddy/"
        "/home/jp/data/gotify/"
        "/home/jp/data/focalboard/"
        "/home/jp/data/wallabag/"
      ];
      pruneOpts = [
        "--keep-daily 7"
        "--keep-weekly 5"
        "--keep-monthly 12"
        "--keep-yearly 5"
      ];
      repository = "rclone:onedrive:backups/lazarus";
      passwordFile = "/root/restic-default.password";
      extraBackupArgs = [
        "--verbose"
      ];
    };
  };

  environment.systemPackages = with pkgs; [
    (let
      extra-packages = python-packages: with python-packages; [
        docker
        # other python packages you want
      ];
      pythonWithStuf = python3.withPackages extra-packages;
    in
    pythonWithStuf
    )
  ];
}
