# hosts/death/system.nix
#
# Author: João Borges <RageKnify@gmail.com>
# URL:    https://github.com/RageKnify/Config
#
# System configuration.

{ config, pkgs, ... }:

let
  sshKeys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIC2sdJFvvnEIYztPcznXvKpY4vOWedZ1qzDaAgRxrczS"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIM5IK29XTLu4cHt5V4qoS/OQvHgBf+LtVsSKZygbWueL"
  ];
in {
  modules.graphical.enable = true;

  console.useXkbConfig = true;

  location = {
    provider = "manual";
    # Lisboa, Portugal
    latitude = 38.43;
    longitude = -9.8;
  };

  boot.loader = {
    # Use the systemd-boot EFI boot loader.
    systemd-boot = {
      enable = true;
      editor = false;
      consoleMode = "auto";
      configurationLimit = 20;
    };
    efi.canTouchEfiVariables = true;
  };
  boot = {
    kernelParams = [
      "ip=193.136.164.210::193.136.164.222:255.255.255.224::enp4s0:none"
      "nohibernate"
    ];
    initrd.supportedFilesystems = [ "zfs" ];
    initrd.kernelModules = [ "r8169" ];
    initrd.network = {
      # This will use udhcp to get an ip address.
      # Make sure you have added the kernel module for your network driver to `boot.initrd.availableKernelModules`,
      # so your initrd can load it!
      # Static ip addresses might be configured using the ip argument in kernel command line:
      # https://www.kernel.org/doc/Documentation/filesystems/nfs/nfsroot.txt
      enable = true;
      ssh = {
        enable = true;
        # To prevent ssh clients from freaking out because a different host key is used,
        # a different port for ssh is useful (assuming the same host has also a regular sshd running)
        port = 2222;
        # hostKeys paths must be unquoted strings, otherwise you'll run into issues with boot.initrd.secrets
        # the keys are copied to initrd from the path specified; multiple keys can be set
        # you can generate any number of host keys using
        # `ssh-keygen -t ed25519 -N "" -f /path/to/ssh_host_ed25519_key`
        hostKeys = [ /persist/secrets/initrd/ssh_host_ed25519_key_initrd ];
        # public ssh key used for login
        authorizedKeys = sshKeys;
      };
      # this will automatically load the zfs password prompt on login
      # and kill the other prompt so boot can continue
      postCommands = ''
        cat <<EOF > /root/.profile
        if pgrep -x "zfs" > /dev/null
        then
          zfs load-key -a
          killall zfs
        else
          echo "zfs not running -- maybe the pool is taking some time to load for some unforseen reason."
        fi
        EOF
      '';
    };
  };

  networking = {
    hostName = "death";
    hostId = "5e8c59c3";
    domain = "rnl.tecnico.ulisboa.pt";

    useDHCP = false;

    interfaces.enp4s0 = {
      useDHCP = false;
      wakeOnLan.enable = true;

      ipv4.addresses = [{
        address = "193.136.164.210";
        prefixLength = 27;
      }];

      ipv6.addresses = [{
        address = "2001:690:2100:82::210";
        prefixLength = 64;
      }];
    };

    defaultGateway = "193.136.164.222";
    defaultGateway6 = {
      address = "2001:690:2100:82::ffff:1";
      interface = "enp4s0";
    };

    nameservers = [
      "193.136.164.1"
      "193.136.164.2"
      "2001:690:2100:82::1"
      "2001:690:2100:82::2"
    ];

    search = [ "rnl.tecnico.ulisboa.pt" ];
  };

  boot.cleanTmpDir = true;

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    passwordAuthentication = false;
    challengeResponseAuthentication = false;
    permitRootLogin = "no";
  };

  users = {
    mutableUsers = true;
    users.jp = {
      isNormalUser = true;
      createHome = true;
      shell = pkgs.fish;
      extraGroups = [ "wheel" "video" "libvirtd" "docker" ];
      openssh.authorizedKeys.keys = sshKeys;
    };
  };

  environment.systemPackages = with pkgs; [
    # dev machine
    git
    # virtualization
    virt-manager
  ];

  # virtualization
  programs.dconf.enable = true;
  virtualisation = {
    libvirtd.enable = true;
  };

  virtualisation.docker = {
    enable = true;
    enableOnBoot = false;
  };

  security.pki.certificateFiles = [ ../../config/certs/rnl.crt ];

  services.fwupd.enable = true;

  hardware.enableRedistributableFirmware = true;
}

