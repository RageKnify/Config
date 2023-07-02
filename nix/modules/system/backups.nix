# modules/system/backups.nix
#
# Author: João Borges <RageKnify@gmail.com>
# URL:    https://github.com/RageKnify/Config
#
# restic backups configuration with email on failure.

{ pkgs, config, lib, profiles, ... }:
let
  inherit (lib) mkEnableOption mkOption types mkIf;
  cfg = config.modules.services.backups;
  hostName = config.networking.hostName;
in {
  options.modules.services.backups = {
    enable = mkEnableOption "backups";

    passwordFile = mkOption {
      type = types.path;
      description = lib.mdDoc ''
        Read the repository password from a file.
      '';
      example = "config.age.secrets.resticPassword.path";
    };

    environmentFile = mkOption {
      type = types.path;
      description = lib.mdDoc ''
        file containing the credentials to access the repository, in the format of an EnvironmentFile as described by systemd.exec(5)
      '';
      example = "config.age.secrets.resticEnvironment.path";
    };

    paths = mkOption {
      type = types.nullOr (types.listOf types.str);
      default = null;
      description = lib.mdDoc ''
        Which paths to backup. If null or an empty array, no
        backup command will be run. This can be used to create a
        prune-only job.
      '';
      example = [ "/var/lib/postgresql" "/home/user/backup" ];
    };

    dynamicFilesFrom = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = lib.mdDoc ''
        A script that produces a list of files to back up.
        The results of this command are given to the
        ‘–files-from’ option.
      '';
      example = [ "find /home/matt/git -type d -name .git" ];
    };

    backupPrepareCommand = mkOption {
      type = with types; nullOr str;
      default = null;
      description = lib.mdDoc ''
        A script that must run before starting the backup process.
      '';
    };

    backupCleanupCommand = mkOption {
      type = with types; nullOr str;
      default = null;
      description = lib.mdDoc ''
        A script that must run after finishing the backup process.
      '';
    };
  };

  config = mkIf cfg.enable (let
    resticName = "systemBackup";
    # must match the restic module config
    # https://github.com/NixOS/nixpkgs/blob/660e7737851506374da39c0fa550c202c824a17c/nixos/modules/services/backup/restic.nix#L294
    systemdServiceName = "restic-backups-${resticName}";
    systemdFailServiceName = "${systemdServiceName}-fail";
  in {
    # ensure all hosts have a working sendmail
    modules.msmtp.enable = !config.mailserver.enable;

    services.restic.backups.${resticName} = {
      repository = "b2:restic-jborges:${hostName}";

      passwordFile = cfg.passwordFile;

      environmentFile = cfg.environmentFile;

      paths = cfg.paths;

      dynamicFilesFrom = cfg.dynamicFilesFrom;

      pruneOpts = [
        "--keep-last 20"
        "--keep-daily 7"
        "--keep-weekly 4"
        "--keep-monthly 6"
        "--keep-yearly 3"
      ];

      backupPrepareCommand = cfg.backupPrepareCommand;
      backupCleanupCommand = cfg.backupCleanupCommand;
    };

    # email for failures
    systemd.services.${systemdServiceName} = {
      onFailure = [ "${systemdFailServiceName}.service" ];
    };
    systemd.services.${systemdFailServiceName} = {
      restartIfChanged = false;
      serviceConfig = {
        Type = "oneshot";
        ExecStart = pkgs.writeShellScript "backup-failed-mail.sh" ''
          /run/wrappers/bin/sendmail -t \
          -f '"${hostName}" <${hostName}@jborges.eu>' << MESSAGE_END
          From: "${hostName}" <${hostName}@jborges.eu>
          To: "robots" <robots@jborges.eu>
          Subject: Backup Failed for ${hostName}
          MESSAGE_END
        '';
      };
    };

  });
}
