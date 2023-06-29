# hosts/lazarus/system.nix
#
# Author: João Borges <RageKnify@gmail.com>
# URL:    https://github.com/RageKnify/Config
#
# System configuration.

{ pkgs, lib, sshKeys, config, hostSecretsDir, profiles, ... }: {
  imports = with profiles; [ common server.full ];

  users = {
    users = { jp.openssh.authorizedKeys.keys = sshKeys; };
    users.root = {
      hashedPassword = "$6$alrahBvGoXcPCyLt$7uDj.6W7Ca436Z9o/TrIJhitplMix.7EcFz3uDcuDD75z7CPpeQOeobjRcNnPJOAEJ.CyhoL.2AHivHFSXJsf.";
    };
    mutableUsers = false;
  };

  networking = {
    networkmanager.enable = false;
    useDHCP = false;

    nameservers = [ "1.1.1.1" ];

    interfaces.ens3 = {
      useDHCP = false;

      ipv4.addresses = [{
        address = "185.162.250.236";
        prefixLength = 22;
      }];

      ipv6.addresses = [{
        address = "2a03:4000:1a:1d4::1";
        prefixLength = 64;
      }];

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
