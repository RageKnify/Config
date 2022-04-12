# hosts/war/system.nix
#
# Author: João Borges <RageKnify@gmail.com>
# URL:    https://github.com/RageKnify/Config
#
# System configuration.

{ config, pkgs, configDir, user, ... }:
let
  compiledLayout = pkgs.runCommand "keyboard-layout" {} ''
    ${pkgs.xorg.xkbcomp}/bin/xkbcomp ${configDir}/xkbmap $out
  '';
in
{
  modules.graphical.enable = true;

  console.useXkbConfig = true;

  location = {
    provider = "manual";
    # Lisboa, Portugal
    latitude = 38.43;
    longitude = -9.8;
  };

  services.tlp.enable = true;

  services.upower.enable = true;

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot = {
    enable = true;
    editor = false;
    consoleMode = "auto";
  };
  boot.loader.efi.canTouchEfiVariables = true;

  boot.supportedFilesystems = [ "zfs" ];
  boot.kernelParams = [ "nohibernate" ];
  boot.zfs.devNodes = "/dev";

  services.zfs = {
    trim.enable = true;
    autoScrub.enable = true;
    autoScrub.pools = [ "rpool" ];
  };

  networking.hostId = "48a4b691";
  networking.networkmanager = {
    enable = true;
  };
  networking.wg-quick.interfaces = {
    wgrnl = {
      address = [ "192.168.20.13/24" "fd92:3315:9e43:c490::13/64" ];
      dns = [
      "193.136.164.1"
      "193.136.164.2"
      "2001:690:2100:80::1"
      "2001:690:2100:80::2"
      ];
      privateKeyFile = "/etc/nixos/secrets/wg-privkey";
      table = "765";
      postUp = ''
        ${pkgs.wireguard-tools}/bin/wg set wgrnl fwmark 765
        ${pkgs.iproute2}/bin/ip rule add not fwmark 765 table 765
        ${pkgs.iproute2}/bin/ip -6 rule add not fwmark 765 table 765
      '';
      postDown = ''
        ${pkgs.iproute2}/bin/ip rule del not fwmark 765 table 765
        ${pkgs.iproute2}/bin/ip -6 rule del not fwmark 765 table 765
      '';
      peers = [
        {
          publicKey = "g08PXxMmzC6HA+Jxd+hJU0zJdI6BaQJZMgUrv2FdLBY=";
          endpoint = "193.136.164.211:34266";
          allowedIPs = [
            "193.136.164.0/24"
            "193.136.154.0/24"
            "10.16.64.0/18"
            "2001:690:2100:80::/58"
            "193.136.128.24/29"
            "146.193.33.81/32"
            "192.168.154.0/24"
          ];
          persistentKeepalive = 25;
        }
      ];
    };
  };

  boot.cleanTmpDir = true;

  # For when I have more RAM
  # zramSwap.enable = true;

  users = {
    mutableUsers = true;
    users.jp = {
      isNormalUser = true;
      createHome = true;
      shell = pkgs.fish;
      extraGroups = [ "wheel" "video" "libvirtd" "docker" ];
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
