# modules/system/backups.nix
#
# Author: João Borges <RageKnify@gmail.com>
# URL:    https://github.com/RageKnify/Config
#
# restic backups configuration with email on failure.

{ pkgs, config, lib, utils, ... }:
let
  inherit (lib) mkEnableOption mkOption types mkIf;
  cfg = config.modules.services.backups;
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
    services.restic.backups.${resticName} = {
      repository = "b2:restic-jborges:${config.networking.hostName}";

      passwordFile = cfg.passwordFile;

      environmentFile = cfg.environmentFile;

      paths = cfg.paths;
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
        ${pkgs.postfix}/bin/sendmail -i -t << MESSAGE_END
From: "${config.networking.hostName}" <robots@jborges.eu>
To: "robots" <robots@jborges.eu>
Subject: Backup Failed for ${config.networking.hostName}

MESSAGE_END
        '';
      };
    };

  });
}
