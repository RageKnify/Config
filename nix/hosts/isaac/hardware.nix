{ pkgs, lib, config, modulesPath, ... }:
let
  disks = [
    "disk/by-id/ata-ST2000DM008-2UB102_WFL624CS"
    "disk/by-id/ata-ST2000DM008-2UB102_WFL66DD0"
  ];
in {
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];
  boot.kernelModules = [ ];
  boot.extraModulePackages = [ ];
  boot.supportedFilesystems = [ "zfs" ];
  boot.kernelPackages = config.boot.zfs.package.latestCompatibleLinuxPackages;

  boot.zfs.devNodes = "/dev/disk/by-id";

  boot.loader.grub = {
    enable = true;
    efiSupport = true;
    efiInstallAsRemovable = true;
    splashImage = null;

    # Something is wrong with the grub module, mirroredBoots[].devices
    # are showing up in grub.devices, so I force it empty
    devices = lib.mkForce [ ];

    mirroredBoots = lib.lists.imap0 (idx: devName: {
      path = "/boot${builtins.toString idx}";
      devices = [ "/dev/${devName}" ];
    }) disks;
  };

  disko.devices = {
    disk = builtins.listToAttrs (lib.lists.imap0 (idx: devName: {
      name = "${builtins.toString idx}";
      value = {
        type = "disk";
        device = "/dev/${devName}";
        content = {
          type = "gpt";
          partitions = {
            boot = {
              size = "1M";
              type = "EF02"; # for legacy boot
            };
            ESP = {
              size = "512M";
              type = "EF00"; # for EFI boot
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot${builtins.toString idx}";
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
    }) disks);
    zpool = {
      rpool = {
        type = "zpool";
        mode = "mirror";
        options = {
          ashift = "12";
        };
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
        datasets = {
          "local/nix" = {
            type = "zfs_fs";
            mountpoint = "/nix";
            mountOptions = [ "zfsutil" ];
          };
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
  networking.hostId = "150dbc29";

  zramSwap = {
    enable = true;
    memoryPercent = 150;
  };
}
