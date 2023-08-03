{ config, lib, pkgs, ... }: {
  services.zfs.zed = {
    settings = {
      ZFS_DEBUG_LOG = "/tmp/zed.debug.log";

      ZED_EMAIL_ADDR = [ "me+robots@jborges.eu" ];
      ZED_EMAIL_PROG = "${pkgs.system-sendmail}/bin/sendmail";
      ZED_EMAIL_OPTS = "@ADDRESS@";

      ZED_NOTIFY_VERBOSE = true;
    };
  };
}
