{ config, options, lib, pkgs, ... }:
with lib;
let
  cfg = config.services.firefly-iii;
  fpm = config.services.phpfpm.pools.firefly-iii;

  inherit (cfg) datadir;
  inherit (strings) optionalString;

  mysqlLocal = cfg.database.createLocally && cfg.config.dbtype == "mysql";
  pgsqlLocal = cfg.database.createLocally && cfg.config.dbtype == "pgsql";

  wrappedArtisan = pkgs.writeShellScriptBin "artisan-firefly-iii" ''
    #!/bin/sh
    if [ "$UID" == "0" ]; then
      exec ${pkgs.util-linux}/bin/runuser -u "firefly-iii" -- "$0" "$@"
    fi

    ${builtins.concatStringsSep "\n" (builtins.attrValues
      (builtins.mapAttrs (name: value: "export ${name}=${value}") fireflyEnv))}

    # load app key
    source '${appKeyEnvPath}'
    export APP_KEY

    exec ${cfg.package}/share/php/firefly-iii/artisan "$@"
  '';

  laravelEnv = {
    # https://github.com/laravel/framework/blob/38fa79eaa22b95446b92db222d89ec04a7ef10c7/src/Illuminate/Foundation/Application.php look for env vars ($_ENV and normalizeCachePath)
    LARAVEL_STORAGE_PATH = "${datadir}/storage";
    APP_SERVICES_CACHE = "${datadir}/cache/services.php";
    APP_PACKAGES_CACHE = "${datadir}/cache/packages.php";
    APP_CONFIG_CACHE = "${datadir}/cache/config.php";
    APP_ROUTES_CACHE = "${datadir}/cache/routes-v7.php";
    APP_EVENTS_CACHE = "${datadir}/cache/events.php";
  };

  fireflyEnv = laravelEnv // {
    APP_ENV = "production";
    SITE_OWNER = "${cfg.adminAddr}";
    MAIL_SENDMAIL_COMMAND = "\"/run/wrappers/bin/sendmail -t\"";
    DEFAULT_LOCALE = (builtins.substring 0 5 config.i18n.defaultLocale);
    TZ = config.time.timeZone;

    DB_CONNECTION = "${cfg.config.dbtype}";
    DB_DATABASE = "${cfg.config.dbname}";
    DB_USERNAME = "${cfg.config.dbuser}";
    DB_HOST = "${cfg.config.dbhost}";
    APP_URL = "http${(optionalString cfg.https "s")}://${cfg.hostName}";
  } // lib.attrsets.optionalAttrs (cfg.config.dbport != null) {
    DB_PORT = "${toString cfg.config.dbport}";
  };

  appKeyEnvPath = "${datadir}/app_key.env";
in {
  options.services.firefly-iii = {
    enable = mkEnableOption (lib.mdDoc "Firefly III");

    hostName = mkOption {
      type = types.str;
      description = lib.mdDoc "FQDN for the Firefly III instance.";
    };
    home = mkOption {
      type = types.str;
      default = "/var/lib/firefly-iii";
      description = lib.mdDoc "Storage path of Firefly III.";
    };
    datadir = mkOption {
      type = types.str;
      default = config.services.firefly-iii.home;
      defaultText = literalExpression "config.services.firefly.home";
      description = lib.mdDoc ''
        Firefly III's data storage path.  Will be [](#opt-services.firefly.home) by default.
      '';
      example = "/mnt/firefly-file";
    };
    https = mkOption {
      type = types.bool;
      default = false;
      description = lib.mdDoc "Use HTTPS for generated links.";
    };
    # package = mkOption {
    #   type = types.package;
    #   default = pkgs.firefly-iii;
    #   description =
    #     lib.mdDoc "Which package to use for the Firefly III instance.";
    # };
    phpPackage = mkOption {
      type = types.package;
      default = pkgs.php83;
      description = lib.mdDoc ''
        PHP package to use for Firfefly III.
      '';
    };

    adminAddr = mkOption {
      type = types.nullOr types.str;
      default = null;
      example = "admin@example.org";
      description = lib.mdDoc "E-mail address of the server administrator.";
    };

    poolSettings = mkOption {
      type = with types; attrsOf (oneOf [ str int bool ]);
      default = {
        "pm" = "dynamic";
        "pm.max_children" = "32";
        "pm.start_servers" = "2";
        "pm.min_spare_servers" = "2";
        "pm.max_spare_servers" = "4";
        "pm.max_requests" = "500";
      };
      description = lib.mdDoc ''
        Options for Firefly III's PHP pool. See the documentation on `php-fpm.conf` for details on configuration directives.
      '';
    };

    poolConfig = mkOption {
      type = types.nullOr types.lines;
      default = null;
      description = lib.mdDoc ''
        Options for Firefly III's PHP pool. See the documentation on `php-fpm.conf` for details on configuration directives.
      '';
    };

    database = {

      createLocally = mkOption {
        type = types.bool;
        default = false;
        description = lib.mdDoc ''
          Whether to create the database and database user locally.
        '';
      };

    };

    config = {
      dbtype = mkOption {
        type = types.enum [ "sqlite" "pgsql" "mysql" ];
        default = "sqlite";
        description = lib.mdDoc "Database type.";
      };
      dbname = mkOption {
        type = types.nullOr types.str;
        default = "firefly-iii";
        description = lib.mdDoc "Database name.";
      };
      dbuser = mkOption {
        type = types.nullOr types.str;
        default = "firefly-iii";
        description = lib.mdDoc "Database user.";
      };
      dbpassFile = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = lib.mdDoc ''
          The full path to a file that contains the database password.
        '';
      };
      dbhost = mkOption {
        type = types.nullOr types.str;
        default = if pgsqlLocal then
          "/run/postgresql"
        else if mysqlLocal then
          "localhost:/run/mysqld/mysqld.sock"
        else
          "localhost";
        defaultText = "localhost";
        description = lib.mdDoc ''
          Database host or socket path.
          If [](#opt-services.firefly-iii.database.createLocally) is true and
          [](#opt-services.firefly-iii.config.dbtype) is either `pgsql` or `mysql`,
          defaults to the correct Unix socket instead.
        '';
      };
      dbport = mkOption {
        type = with types; nullOr (either int str);
        default =
          if pgsqlLocal then 5432 else if mysqlLocal then 3306 else null;
        description = lib.mdDoc "Database port.";
      };
    };

    environmentFile = mkOption {
      type = types.path;
      description = lib.mdDoc ''
        file containing enviroment variables, in the format of an EnvironmentFile as described by systemd.exec(5)
        useful for mail credentials
      '';
      example = "config.age.secrets.fireflyEnvironment.path";
    };

    nginx = {
      recommendedHttpHeaders = mkOption {
        type = types.bool;
        default = true;
        description =
          lib.mdDoc "Enable additional recommended HTTP response headers";
      };
      hstsMaxAge = mkOption {
        type = types.ints.positive;
        default = 15552000;
        description = lib.mdDoc ''
          Value for the `max-age` directive of the HTTP
          `Strict-Transport-Security` header.

          See section 6.1.1 of IETF RFC 6797 for detailed information on this
          directive and header.
        '';
      };
    };
  };

  config = mkIf cfg.enable (mkMerge [
    {
      assertions = [{
        assertion = cfg.database.createLocally -> cfg.config.dbpassFile == null;
        message = ''
          Using `services.firefly-iii.database.createLocally` with database
          password authentication is no longer supported.

          If you use an external database (or want to use password auth for any
          other reason), set `services.firefly-iii.database.createLocally` to
          `false`. The database won't be managed for you (use `services.mysql`
          if you want to set it up).

          If you want this module to manage your Firefly III database for you,
          unset `services.firefly-iii.config.dbpassFile` and
          `services.firefly-iii.config.dbhost` to use socket authentication
          instead of password.
        '';
      }];
    }

    {
      systemd.timers.firefly-iii-cron = {
        unitConfig.Description = "Firefly III cron";
        timerConfig.OnCalendar = "daily";
        wantedBy = [ "timers.target" ];
      };

      systemd.services = {
        laravelsetup-firefly-iii = {
          description =
            "Setup storage directories for a Laravel-based web application";
          # Only run when datadir does not yet contain the mount target
          unitConfig.ConditionPathExists = "!${appKeyEnvPath}";
          serviceConfig = {
            Type = "oneshot";
            User = "firefly-iii";
            Group = "firefly-iii";
          };
          script = let
            setupScript = pkgs.writeShellScript "setup-laravel.sh" ''
              set -e

              # keep data private (including the app key which will be generated here)
              umask 0007

              # ensure storage dir matches Laravel's expectations and is writable
              ${pkgs.rsync}/bin/rsync --ignore-existing -r ${cfg.package}/share/php/firefly-iii/storage ${datadir}/
              chmod -R u+w ${datadir}/storage

              # ensure bootstrap/cache-equivalent directory exists (will be writable)
              mkdir -p ${datadir}/cache

              # generate a new app key (but must set a dummy one, as Laravel demands one to exist for artisan to function)
              echo "APP_KEY=$(APP_KEY=aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa '${wrappedArtisan}/bin/artisan-firefly-iii' --no-ansi key:generate --show)" > '${appKeyEnvPath}'
            '';
          in ''
            ${setupScript} || { rm '${appKeyEnvPath}'; exit 1; }
          '';
        };
        firefly-iii-setup = {
          description = "Setup Firefly III's database";
          wantedBy = [ "multi-user.target" ];
          before = [ "phpfpm-firefly-iii.service" ];
          after = optional mysqlLocal "mysql.service" ++ optional pgsqlLocal "postgresql.service";
          requires = optional mysqlLocal "mysql.service" ++ optional pgsqlLocal "postgresql.service";
          serviceConfig = {
            Type = "oneshot";
            User = "firefly-iii";
            Group = "firefly-iii";
          };
          script = ''
          # They appear to be idempotent operations
          ${wrappedArtisan}/bin/artisan-firefly-iii firefly-iii:upgrade-database
          ${wrappedArtisan}/bin/artisan-firefly-iii firefly-iii:correct-database
          ${wrappedArtisan}/bin/artisan-firefly-iii firefly-iii:report-integrity
          ${wrappedArtisan}/bin/artisan-firefly-iii passport:install
          '';
        };
        firefly-iii-cron = {
          description = "Firefly III cron";
          requires = [ "nginx.service" "phpfpm-firefly-iii.service" ];
          wantedBy = [ "phpfpm-firefly-iii.service" ];
          after = [
            "nginx.service"
            "phpfpm-firefly-iii.service"
            "postgresql.service" # TODO: this should depend on chosen database
          ];
          serviceConfig.Type = "oneshot";
          serviceConfig.User = "firefly-iii";
          serviceConfig.Group = "firefly-iii";
          serviceConfig.EnvironmentFile = cfg.environmentFile;
          environment = fireflyEnv;
          script = ''
            ${wrappedArtisan}/bin/artisan-firefly-iii firefly-iii:cron
          '';
        };
        phpfpm-firefly-iii = {
          requires = [
            "laravelsetup-firefly-iii.service"
            # require DB for PHP, to avoid weird cascading errors
            "postgresql.service"
          ];
          after = [ "laravelsetup-firefly-iii.service" ];
          serviceConfig.EnvironmentFile = [ appKeyEnvPath cfg.environmentFile ];
          restartTriggers =
            [ config.systemd.services."laravelsetup-firefly-iii".script ];
        };
      };

      services.phpfpm.pools.firefly-iii = {
        user = "firefly-iii";
        group = "firefly-iii";
        phpPackage = cfg.phpPackage;
        phpEnv = fireflyEnv // {
          APP_KEY = "$APP_KEY"; # load from phpfpm service env
          MAIL_MAILER = "$MAIL_MAILER";
        };
        settings = mapAttrs (name: mkDefault) {
          "listen.owner" = config.services.nginx.user;
          "listen.group" = config.services.nginx.group;
        } // cfg.poolSettings;
        extraConfig = cfg.poolConfig;
      };

      users.users.firefly-iii = {
        home = "${cfg.home}";
        group = "firefly-iii";
        isSystemUser = true;
        packages = [ wrappedArtisan ];
      };
      users.groups.firefly-iii.members =
        [ "firefly-iii" config.services.nginx.user ];

      services.mysql = lib.mkIf mysqlLocal {
        enable = true;
        package = lib.mkDefault pkgs.mariadb;
        ensureDatabases = [ cfg.config.dbname ];
        ensureUsers = [{
          name = cfg.config.dbuser;
          ensurePermissions = { "${cfg.config.dbname}.*" = "ALL PRIVILEGES"; };
        }];
      };

      services.postgresql = mkIf pgsqlLocal {
        enable = true;
        ensureDatabases = [ cfg.config.dbname ];
        ensureUsers = [{
          name = cfg.config.dbuser;
          ensureDBOwnership = true;
        }];
      };

      services.nginx.enable = mkDefault true;

      services.nginx.virtualHosts.${cfg.hostName} = {
        root = "${cfg.package}/share/php/firefly-iii/public";
        locations = {
          "/".tryFiles = "$uri @rewriteapp";
          "@rewriteapp".extraConfig = ''
            # rewrite all to index.php
            rewrite ^(.*)$ /index.php last;
          '';
          "~ \\.php$" = {
            extraConfig = ''
              fastcgi_split_path_info ^(.+\.php)(/.+)$;
              fastcgi_pass unix:${fpm.socket};
              include ${pkgs.nginx}/conf/fastcgi_params;
              include ${pkgs.nginx}/conf/fastcgi.conf;
              fastcgi_param HTTP_PROXY ""; # something something HTTPoxy
              fastcgi_param HTTPS ${if cfg.https then "on" else "off"};
            '';
          };
        };
        extraConfig = ''
          index index.php index.html /index.php$request_uri;
          ${optionalString (cfg.nginx.recommendedHttpHeaders) ''
            add_header X-Content-Type-Options nosniff;
            add_header X-XSS-Protection "1; mode=block";
            add_header X-Robots-Tag "noindex, nofollow";
            add_header X-Download-Options noopen;
            add_header X-Permitted-Cross-Domain-Policies none;
            add_header X-Frame-Options sameorigin;
            add_header Referrer-Policy no-referrer;
          ''}
          ${optionalString (cfg.https) ''
            add_header Strict-Transport-Security "max-age=${
              toString cfg.nginx.hstsMaxAge
            }; includeSubDomains" always;
          ''}
          fastcgi_buffers 64 4K;
          fastcgi_hide_header X-Powered-By;
          gzip on;
          gzip_vary on;
          gzip_comp_level 4;
          gzip_min_length 256;
          gzip_proxied expired no-cache no-store private no_last_modified no_etag auth;
          gzip_types application/atom+xml application/javascript application/json application/ld+json application/manifest+json application/rss+xml application/vnd.geo+json application/vnd.ms-fontobject application/x-font-ttf application/x-web-app-manifest+json application/xhtml+xml application/xml font/opentype image/bmp image/svg+xml image/x-icon text/cache-manifest text/css text/plain text/vcard text/vnd.rim.location.xloc text/vtt text/x-component text/x-cross-domain-policy;
        '';
      };
    }
  ]);
}
