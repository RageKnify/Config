{ config, ... }: {
  boot.supportedFilesystems = [ "zfs" ];

  boot.kernelPackages = config.boot.zfs.package.latestCompatibleLinuxPackages;

  services.zfs = {
    autoScrub = {
      enable = true;
      interval = "Sunday, 02:00";
    };
    trim = {
      enable = true;
      interval = "Sunday, 03:00";
    };
  };
}
