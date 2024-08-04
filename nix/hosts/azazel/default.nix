# hosts/lazarus/system.nix
#
# Author: João Borges <RageKnify@gmail.com>
# URL:    https://github.com/RageKnify/Config
#
# System configuration.

{ pkgs, lib, sshKeys, config, hostSecretsDir, profiles, ... }: {
  imports = with profiles.nixos; [
    common
    docker
    focalboard
    server.full
    acme.common
    acme.dns-jborges-eu
    acme.dns-jplborges-pt
    mail
    nginx.common
    nginx.jborges-eu
    nginx.r-jplborges-pt
    proxy
    vpn.headscale
    vpn.tailscale
    wallabag
    zfs.common
    zfs.email
    ./hardware.nix
  ];

  modules = {
    services.backups = {
      enable = true;

      passwordFile = config.age.secrets.resticPassword.path;

      environmentFile = config.age.secrets.backupEnvFile.path;
    };
    syncthing = {
      enable = true;
    };
  };

  age.secrets = {
    resticPassword.file = "${hostSecretsDir}/resticPassword.age";
    backupEnvFile.file = "${hostSecretsDir}/backupEnvFile.age";
  };

  users = {
    users.root = {
      hashedPassword =
        "$6$alrahBvGoXcPCyLt$7uDj.6W7Ca436Z9o/TrIJhitplMix.7EcFz3uDcuDD75z7CPpeQOeobjRcNnPJOAEJ.CyhoL.2AHivHFSXJsf.";
    };
    mutableUsers = false;
  };

  home-manager.users.jp = {
    imports = with profiles.home; [ fish neovim tmux ];

    modules = { git.enable = true; };

    home.stateVersion = "21.11";
  };

  networking = {
    networkmanager.enable = false;
    useDHCP = false;

    interfaces.ens3 = {
      useDHCP = false;

      ipv4.addresses = [{
        address = "185.162.250.236";
        prefixLength = 22;
      }];

      ipv6.addresses = [
        {
          address = "2a03:4000:1a:1d4::1";
          prefixLength = 64;
        }
        {
          # mail.jborges.eu
          address = "2a03:4000:1a:1d4::236";
          prefixLength = 64;
        }
      ];

    };

    defaultGateway = "185.162.248.1";

    defaultGateway6 = {
      address = "fe80::1";
      interface = "ens3";
    };
  };

  services.openssh = {
    hostKeys = [{
      path = "/persist/etc/ssh/ssh_host_ed25519_key";
      type = "ed25519";
    }];
  };

  system.stateVersion = "23.05";
}
