# hosts/conquest/hardware.nix
#
# Author: João Borges <RageKnify@gmail.com>
# URL:    https://github.com/RageKnify/Config
#
# hardware configuration.

{ pkgs, lib, config, modulesPath, ... }:
let
  hdd_s = [
    "disk/by-id/ata-ST2000DM008-2UB102_WFL624CS"
    "disk/by-id/ata-ST2000DM008-2UB102_WFL66DD0"
  ];
  ssd = "disk/by-id/ata-CT250BX100SSD1_1513F0055122";
in {
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];
  boot.initrd.availableKernelModules =
    [ "xhci_pci" "ehci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" ];
  hardware.cpu.intel.updateMicrocode =
    lib.mkDefault config.hardware.enableRedistributableFirmware;
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];
  boot.supportedFilesystems = [ "zfs" ];

  boot.zfs.devNodes = "/dev/disk/by-id";

  boot.loader.systemd-boot = {
    enable = true;
    editor = false;
    consoleMode = "auto";
    configurationLimit = 10;
  };

  disko.devices = {
    disk = builtins.listToAttrs (lib.lists.imap0 (idx: devName: {
      name = "hdd${builtins.toString idx}";
      value = {
        type = "disk";
        device = "/dev/${devName}";
        content = {
          type = "gpt";
          partitions = {
            dpool = {
              size = "100%";
              content = {
                type = "zfs";
                pool = "dpool";
              };
            };
          };
        };
      };
    }) hdd_s) // {
      ssd = {
        type = "disk";
        device = "/dev/${ssd}";
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              size = "512M";
              type = "EF00"; # for EFI boot
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [ "defaults" "nofail" ];
              };
            };
            rpool = {
              size = "100%";
              content = {
                type = "zfs";
                pool = "rpool";
              };
            };
          };
        };
      };
    };
    zpool = let
      rootFsOptions = {
        acltype = "posixacl";
        atime = "off";
        canmount = "off";
        compression = "zstd";
        dnodesize = "auto";
        normalization = "formD";
        xattr = "sa";
        mountpoint = "none";
      };
    in {
      rpool = {
        type = "zpool";
        options = { ashift = "12"; };
        inherit rootFsOptions;
        datasets = {
          "local/reserved" = {
            type = "zfs_fs";
            options.mountpoint = "none";
            options.refreservation = "5G";
          };
          "local/nix" = {
            type = "zfs_fs";
            mountpoint = "/nix";
            mountOptions = [ "zfsutil" ];
          };
        };
      };
      dpool = {
        type = "zpool";
        mode = "mirror";
        options = { ashift = "12"; };
        inherit rootFsOptions;
        datasets = {
          "local/reserved" = {
            type = "zfs_fs";
            options.mountpoint = "none";
            options.refreservation = "10G";
          };
          "safe/persist" = {
            type = "zfs_fs";
            mountpoint = "/persist";
            mountOptions = [ "zfsutil" ];
          };
          "safe/home" = {
            type = "zfs_fs";
            mountpoint = "/home";
            mountOptions = [ "zfsutil" ];
          };
        };
      };
    };
    nodev."/" = {
      fsType = "tmpfs";
      mountOptions = [ "size=2G" "defaults" "mode=755" ];
    };
  };

  # sadly disko can't handle this for us
  fileSystems."/persist".neededForBoot = true;

  environment.persistence."/persist".files = [ "/etc/machine-id" ];
  environment.persistence."/persist".directories = [ "/var/lib/nixos" ];
  networking.hostId = "3a5b81c2";

  zramSwap = {
    enable = true;
    memoryPercent = 150;
  };
}
