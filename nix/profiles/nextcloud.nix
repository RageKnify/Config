{ pkgs, lib, config, hostSecretsDir, ... }:
let
  resticBackupServiceName =
    "${config.modules.services.backups.systemdServiceName}.service";
  postgresBackupServiceName = "postgresqlBackup.service" ;
in {
  age.secrets.nextcloud-admin-pass = {
    file = "${hostSecretsDir}/nextcloud-admin-pass.age";
    owner = "nextcloud";
    group = "nextcloud";
  };

  services = {
    nextcloud = {
      enable = true;
      package = pkgs.nextcloud28; # Need to manually increment with every update
      hostName = "cloud.jborges.eu";

      https = true;
      autoUpdateApps = {
        enable = true;
        startAt = "06:00";
      };

      extraAppsEnable = true;
      extraApps = with config.services.nextcloud.package.packages.apps; {
        inherit calendar contacts tasks;
        # cookbook = pkgs.fetchNextcloudApp rec {
        #   url =
        #     "https://github.com/nextcloud/cookbook/releases/download/v0.10.2/Cookbook-0.10.2.tar.gz";
        #   sha256 = "sha256-XgBwUr26qW6wvqhrnhhhhcN4wkI+eXDHnNSm1HDbP6M=";
        #   license = lib.licenses.agpl3Plus;
        # };
      };

      config = {
        overwriteProtocol = "https";
        defaultPhoneRegion = "PT";

        trustedProxies = [ "100.64.0.1" ]; # azazel.bible.jborges.eu

        dbtype = "pgsql";

        adminuser = "admin";
        adminpassFile = config.age.secrets.nextcloud-admin-pass.path;
      };

      database.createLocally = true;

      caching.apcu = true;
    };
  };

  environment.persistence."/persist".directories = [{
    directory = config.services.nextcloud.home;
    user = "nextcloud";
    group = "nextcloud";
  }];

  # Backup notes:
  # - https://docs.nextcloud.com/server/latest/admin_manual/maintenance/backup.html
  # - https://docs.nextcloud.com/server/latest/admin_manual/maintenance/restore.html
  # - /var/lib/nextcloud must be owned by nextcloud (sudo chown -R nextcloud: /var/lib/nextcloud)

  # enter maintenance mode before database dump
  systemd.services.nextcloudStartMaintenance = {
    serviceConfig = {
      User = "nextcloud";
      Type = "oneshot";
      ExecStart = pkgs.writeShellScript "nextcloudStartMaintenance.sh" ''
        ${config.services.nextcloud.occ}/bin/nextcloud-occ maintenance:mode --on
      '';
    };
    description = "enable nextcloud maintenance mode";
    wantedBy = [ postgresBackupServiceName ];
    before = [ postgresBackupServiceName ];
    restartIfChanged = false;
  };

  # leave maintenance mode after filesystem backup
  systemd.services.nextcloudEndMaintenance = {
    serviceConfig = {
      User = "nextcloud";
      Type = "oneshot";
      ExecStart = pkgs.writeShellScript "nextcloudStartMaintenance.sh" ''
        ${config.services.nextcloud.occ}/bin/nextcloud-occ maintenance:mode --off
      '';
    };
    description = "disable nextcloud maintenance mode";
    wantedBy = [ resticBackupServiceName ];
    after = [ resticBackupServiceName ];
    restartIfChanged = false;
  };

  modules.services.backups.paths =
    [ "/persist/${config.services.nextcloud.home}/" ];
}
