# modules/system/postgresql.nix
#
# Author: João Borges <RageKnify@gmail.com>
# URL:    https://github.com/RageKnify/Config
#
# postgresql configuration.

{
  pkgs,
  config,
  lib,
  profiles,
  ...
}:
let
  inherit (lib)
    mkEnableOption
    mkOption
    types
    mkIf
    ;
  inherit (config.networking) hostName;
  cfg = config.services.postgresql;
  backupFailServiceName = "postgresqlBackupFail";
  resticBackupServiceName = config.modules.services.backups.systemdServiceName;
in
{
  config = mkIf (cfg.ensureDatabases != [ ]) {
    services.postgresql = {
      enable = true;
      package = pkgs.postgresql_16;
    };

    # Create dumps of all databases
    services.postgresqlBackup = {
      enable = true;
      compression = "zstd";
    };

    systemd.services.postgresqlBackup = {
      onFailure = [ "${backupFailServiceName}.service" ];
      startAt = lib.mkForce [ ]; # Disable timer
      # Run this before the restic service
      wantedBy = [ "${resticBackupServiceName}.service" ];
      before = [ "${resticBackupServiceName}.service" ];
    };

    systemd.services.${backupFailServiceName} = {
      restartIfChanged = false;
      serviceConfig = {
        Type = "oneshot";
        ExecStart = pkgs.writeShellScript "postgresqlBackup-failed-mail.sh" ''
          /run/wrappers/bin/sendmail -t \
          -f '"${hostName}" <${hostName}@jborges.eu>' << MESSAGE_END
          From: "${hostName}" <${hostName}@jborges.eu>
          To: "robots" <robots@jborges.eu>
          Subject: postgresqlBackup Failed for ${hostName}
          MESSAGE_END
        '';
      };
    };

    # backup the database dump
    modules.services.backups =
      let
        dumpPath = "${config.services.postgresqlBackup.location}/all.sql.zstd";
      in
      {
        paths = [ dumpPath ];
      };

    environment.persistence."/persist".directories = [
      {
        directory = "/var/lib/postgresql";
        user = "postgresql";
        group = "postgresql";
      }
    ];
  };
}
