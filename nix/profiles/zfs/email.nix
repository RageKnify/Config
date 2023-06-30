{ config, lib, pkgs, ... }: {
  services.zfs.zed = {
    enableMail = true;
    settings = {
      ZED_EMAIL_ADDR = [ "me+zfs@jborges.eu" ];
      ZED_NOTIFY_VERBOSE = true;
    };
  };
}
