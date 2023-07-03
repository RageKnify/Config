# hosts/lazarus/system.nix
#
# Author: João Borges <RageKnify@gmail.com>
# URL:    https://github.com/RageKnify/Config
#
# System configuration.

{ pkgs, lib, sshKeys, profiles, ... }: {
  imports = with profiles; [ common server.full ./hardware.nix ];

  modules = { personal.enable = true; };

  services.zfs = {
    trim.enable = true;
    autoScrub.enable = true;
    autoScrub.pools = [ "rpool" "bpool" ];
  };

  networking = {
    hostId = "5e8c59c3";
    domain = "rnl.tecnico.ulisboa.pt";
    search = [ "tecnico.ulisboa.pt" ];

    useDHCP = false;

    interfaces.enp1s0 = {
      useDHCP = false;
      wakeOnLan.enable = true;

      ipv4.addresses = [{
        address = "193.136.164.171";
        prefixLength = 26;
      }];

      ipv6.addresses = [{
        address = "2001:690:2100:83::171";
        prefixLength = 64;
      }];
    };

    defaultGateway = "193.136.164.190";
    defaultGateway6 = {
      address = "2001:690:2100:83::ffff:1";
      interface = "enp1s0";
    };

    nameservers = [
      "193.136.164.1"
      "193.136.164.2"
      "2001:690:2100:82::1"
      "2001:690:2100:82::2"
    ];
  };

  users = {
    users = {
      root.hashedPassword =
        "$6$DGdSZAJTaUYbM4nR$49euO8k5K5.MRzbUBnzvCypKUdbsQ2453ucThTCISfLo31mgHMq3oXegPfC6c2grL.2.qeMz1SzNMIPxfmv6x/";
    };
  };

  home-manager.users.jp = {
    imports = with profiles.home; [ fish neovim ];
    modules = {
      xdg.enable = true;
      personal.enable = true;
      shell.git.enable = true;
      shell.tmux.enable = true;
    };

    # to enable starhip in nix-shells
    programs.bash.enable = true;

    home.stateVersion = "21.11";
  };

  virtualisation.docker = { enable = true; };
}
