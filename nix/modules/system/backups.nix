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

    backupName = mkOption {
      type = types.str;
      default = "backblazeBackup";
      readOnly = true;
      description = lib.mdDoc ''
        The name of the backup we create.
      '';
    };

    systemdServiceName = mkOption {
      type = types.str;
      default = "restic-backups-${cfg.backupName}";
      readOnly = true;
      description = lib.mdDoc ''
        The name of the systemd service that runs the backup we create.
      '';
    };
  };

  config = mkIf cfg.enable
    (let systemdFailServiceName = "${cfg.systemdServiceName}-fail";
    in {
      services.restic.backups.${cfg.backupName} = {
        repository = "b2:restic-jborges:${hostName}";

        passwordFile = cfg.passwordFile;

        environmentFile = cfg.environmentFile;

        timerConfig = {
          # I might be up at 00:00, should be AFK at 05:00
          OnCalendar = "05:00";
          Persistent = true;
        };

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

      modules.msmtp.enable = true;

      # email for failures
      systemd.services.${cfg.systemdServiceName} = {
        onFailure = [ "${systemdFailServiceName}.service" ];
      };
      systemd.services.${systemdFailServiceName} = {
        restartIfChanged = false;
        serviceConfig = {
          Type = "oneshot";
          ExecStart = pkgs.writeShellScript "backup-failed-mail.sh" ''
            ${pkgs.system-sendmail}/bin/sendmail -t << MESSAGE_END
            To: "robots" <me+robots@jborges.eu>
            Subject: Backup Failed for ${hostName}
            MESSAGE_END
          '';
        };
      };

    });
}
