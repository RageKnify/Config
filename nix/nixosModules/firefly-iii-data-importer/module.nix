{ config, options, lib, pkgs, ... }:
with lib;
let
  cfg = config.services.firefly-iii-data-importer;
  fpm = config.services.phpfpm.pools.firefly-iii-data-importer;

  inherit (cfg) datadir;
  inherit (strings) optionalString;

  wrappedArtisan =
    pkgs.writeShellScriptBin "artisan-firefly-iii-data-importer" ''
      #!/bin/sh
      if [ "$UID" == "0" ]; then
        exec ${pkgs.util-linux}/bin/runuser -u "firefly-iii-data-importer" -- "$0" "$@"
      fi

      ${builtins.concatStringsSep "\n" (builtins.attrValues
        (builtins.mapAttrs (name: value: "export ${name}=${value}")
          fireflyEnv))}

      exec ${cfg.package}/share/php/firefly-iii-data-importer/artisan "$@"
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
    FIREFLY_III_URL = cfg.fireflyUrl;
    VANITY_URL = cfg.fireflyUrl;

    JSON_CONFIGURATION_DIR = cfg.importConfigDir;
    IMPORT_DIR_ALLOWLIST = cfg.importConfigDir;

    APP_ENV = "production";
    ENABLE_MAIL_REPORT = "true";
    MAIL_DESTINATION = cfg.reportsAddr;
    MAIL_SENDMAIL_COMMAND = ''"/run/wrappers/bin/sendmail -t"'';
    DEFAULT_LOCALE = (builtins.substring 0 5 config.i18n.defaultLocale);
    TZ = config.time.timeZone;

    EXPECT_SECURE_URL = "true";
    APP_URL = "http${(optionalString cfg.https "s")}://${cfg.hostName}";
  };
in {
  options.services.firefly-iii-data-importer = {
    enable = mkEnableOption (lib.mdDoc "Firefly III data importer");

    hostName = mkOption {
      type = types.str;
      description =
        lib.mdDoc "FQDN for the Firefly III data importer instance.";
    };
    home = mkOption {
      type = types.str;
      default = "/var/lib/firefly-iii-data-importer";
      description = lib.mdDoc "Storage path of Firefly III data importer.";
    };
    datadir = mkOption {
      type = types.str;
      default = config.services.firefly-iii-data-importer.home;
      defaultText = literalExpression "config.services.firefly.home";
      description = lib.mdDoc ''
        Firefly III data importer's data storage path.  Will be [](#opt-services.firefly.home) by default.
      '';
      example = "/mnt/firefly-file";
    };
    importConfigDir = mkOption {
      type = types.str;
      default = config.services.firefly-iii-data-importer.home
        + "/import-configs";
      description = lib.mdDoc ''
        Firefly III data importer's config storage path.
      '';
      example = "/mnt/firefly-file/import-configs";
    };
    https = mkOption {
      type = types.bool;
      default = false;
      description = lib.mdDoc "Use HTTPS for generated links.";
    };
    # package = mkOption {
    #   type = types.package;
    #   default = pkgs.firefly-iii-data-importer;
    #   description = lib.mdDoc
    #     "Which package to use for the Firefly III data importer instance.";
    # };
    phpPackage = mkOption {
      type = types.package;
      default = pkgs.php83;
      description = lib.mdDoc ''
        PHP package to use for Firfefly III data importer.
      '';
    };

    fireflyUrl = mkOption {
      type = types.str;
      default = null;
      example = "firefly.example.org";
      description = lib.mdDoc "URL of the Firefly III data importer instance.";
    };

    reportsAddr = mkOption {
      type = types.nullOr types.str;
      default = null;
      example = "me@example.org";
      description = lib.mdDoc "E-mail address for the reports.";
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
        Options for Firefly III data importer's PHP pool. See the documentation on `php-fpm.conf` for details on configuration directives.
      '';
    };

    poolConfig = mkOption {
      type = types.nullOr types.lines;
      default = null;
      description = lib.mdDoc ''
        Options for Firefly III data importer's PHP pool. See the documentation on `php-fpm.conf` for details on configuration directives.
      '';
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
      systemd.timers.firefly-iii-data-importer-cron = {
        unitConfig.Description = "Firefly III data importer cron";
        timerConfig.OnCalendar = "23:58";
        wantedBy = [ "timers.target" ];
      };

      systemd.services = {
        laravelsetup-firefly-iii-data-importer = {
          description =
            "Setup storage directories for a Laravel-based web application";
          # Only run when datadir does not yet contain the cache dir
          unitConfig.ConditionPathExists = "!${datadir}/cache";
          serviceConfig = {
            Type = "oneshot";
            User = "firefly-iii-data-importer";
            Group = "firefly-iii-data-importer";
            EnvironmentFile = cfg.environmentFile;
          };
          script = let
            setupScript = pkgs.writeShellScript "setup-laravel.sh" ''
              set -e

              # keep data private (including the app key which will be generated here)
              umask 0007

              # ensure storage dir matches Laravel's expectations and is writable
              ${pkgs.rsync}/bin/rsync --ignore-existing -r ${cfg.package}/share/php/firefly-iii-data-importer/storage ${datadir}/
              chmod -R u+w ${datadir}/storage

              # ensure bootstrap/cache-equivalent directory exists (will be writable)
              mkdir -p ${datadir}/cache

              # ensure importConfigDir exists
              mkdir -p ${cfg.importConfigDir}
            '';
          in ''
            ${setupScript}
          '';
        };
        firefly-iii-data-importer-cron = {
          description = "Firefly III data importer cron";
          requires =
            [ "nginx.service" "phpfpm-firefly-iii-data-importer.service" ];
          wantedBy = [ "phpfpm-firefly-iii-data-importer.service" ];
          after =
            [ "nginx.service" "phpfpm-firefly-iii-data-importer.service" ];
          serviceConfig.Type = "oneshot";
          serviceConfig.User = "firefly-iii-data-importer";
          serviceConfig.Group = "firefly-iii-data-importer";
          serviceConfig.EnvironmentFile = cfg.environmentFile;
          environment = fireflyEnv;
          script = ''
            ${wrappedArtisan}/bin/artisan-firefly-iii-data-importer importer:auto-import ${cfg.importConfigDir}
          '';
        };
        phpfpm-firefly-iii-data-importer = {
          requires = [ "phpfpm-firefly-iii.service" ];
          after = [ "phpfpm-firefly-iii.service" ];
          serviceConfig.EnvironmentFile = cfg.environmentFile;
          restartTriggers = [
            config.systemd.services."laravelsetup-firefly-iii-data-importer".script
          ];
        };
      };

      services.phpfpm.pools.firefly-iii-data-importer = {
        user = "firefly-iii-data-importer";
        group = "firefly-iii-data-importer";
        phpPackage = cfg.phpPackage;
        phpEnv = fireflyEnv // {
          MAIL_MAILER = "$MAIL_MAILER";
          NORDIGEN_ID = "$NORDIGEN_ID";
          NORDIGEN_KEY = "$NORDIGEN_KEY";
        };
        settings = mapAttrs (name: mkDefault) {
          "listen.owner" = config.services.nginx.user;
          "listen.group" = config.services.nginx.group;
        } // cfg.poolSettings;
        extraConfig = cfg.poolConfig;
      };

      users.users.firefly-iii-data-importer = {
        home = "${cfg.home}";
        group = "firefly-iii-data-importer";
        isSystemUser = true;
        packages = [ wrappedArtisan ];
      };
      users.groups.firefly-iii-data-importer.members =
        [ "firefly-iii-data-importer" config.services.nginx.user ];

      services.nginx.enable = mkDefault true;

      services.nginx.virtualHosts.${cfg.hostName} = {
        root = "${cfg.package}/share/php/firefly-iii-data-importer/public";
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
