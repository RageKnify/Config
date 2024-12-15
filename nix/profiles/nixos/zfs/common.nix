{ config, ... }:
{
  boot.supportedFilesystems = [ "zfs" ];

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
