# hosts/death/system.nix
#
# Author: João Borges <RageKnify@gmail.com>
# URL:    https://github.com/RageKnify/Config
#
# System configuration.

{ lib, config, pkgs, sshKeys, ... }:
{
  modules = {
    graphical.enable = true;
    graphical.extraSetupCommands = "${pkgs.xorg.xrandr}/bin/xrandr --output DVI-D-1 --primary --mode 1920x1080 --pos 1080x420 --rotate normal --output HDMI-1 --mode 1920x1080 --pos 0x0 --rotate left --output VGA-1 --off";
    impermanence.enable = true;
  };

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
    timeout = 2;
    efi.canTouchEfiVariables = true;
  };
  boot = {
    kernelParams = [
      "ip=193.136.164.210::193.136.164.222:255.255.255.224::enp4s0:none"
      "nohibernate"
    ];
    initrd.supportedFilesystems = [ "zfs" ];
    initrd.postDeviceCommands = lib.mkAfter ''
      zfs rollback -r zroot/local/root@blank
    '';
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

  services.zfs = {
    trim.enable = true;
    autoScrub.enable = true;
    autoScrub.pools = [ "rpool" ];
  };

  networking = {
    hostId = "5e8c59c3";
    domain = "rnl.tecnico.ulisboa.pt";
    search = [ "tecnico.ulisboa.pt" ];

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
  };

  boot.cleanTmpDir = true;

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    passwordAuthentication = false;
    permitRootLogin = "no";
    authorizedKeysFiles = lib.mkForce [ "/etc/ssh/authorized_keys.d/%u" ];
    challengeResponseAuthentication = false;
    hostKeys = [
      {
        path = "/persist/secrets/ssh/ssh_host_ed25519_key";
        type = "ed25519";
      }
      {
        path = "/persist/secrets/ssh/ssh_host_rsa_key";
        type = "rsa";
        bits = 4096;
      }
    ];
  };

  users.users.root.hashedPassword = "$6$DGdSZAJTaUYbM4nR$49euO8k5K5.MRzbUBnzvCypKUdbsQ2453ucThTCISfLo31mgHMq3oXegPfC6c2grL.2.qeMz1SzNMIPxfmv6x/";
  users.users.jp = {
      openssh.authorizedKeys.keys = sshKeys;
      extraGroups = [ "video" "libvirtd" ];
  };

  environment.systemPackages = with pkgs; [
    # dev machine
    git
    # virtualization
    virt-manager
    # for screen setup
    xorg.xrandr
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

  services.avahi.enable = true;

  # Try to avoid graphical bugs
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.legacy_470;

  services.fwupd.enable = true;

  hardware.enableRedistributableFirmware = true;
}

