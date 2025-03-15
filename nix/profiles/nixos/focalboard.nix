{
  pkgs,
  lib,
  config,
  ...
}:
let
  domain = "focalboard.jplborges.pt";
  port = "2301";
  server_config = (
    pkgs.writeText "server_config.json" (''
      {
        "serverRoot": "http://localhost:8000",
        "port": 8000,
        "dbtype": "sqlite3",
        "dbconfig": "/data/focalboard.db",
        "postgres_dbconfig": "dbname=focalboard sslmode=disable",
        "useSSL": false,
        "webpath": "./pack",
        "filespath": "/data/files",
        "telemetry": true,
        "session_expire_time": 2592000,
        "session_refresh_time": 18000,
        "localOnly": false,
        "enableLocalMode": true,
        "localModeSocketLocation": "/var/tmp/focalboard_local.socket"
      }
    '')
  );
in
{
  environment.persistence."/persist".directories = [
    {
      directory = "/var/lib/focalboard";
      user = "1000";
      group = "100";
    }
  ];

  modules.services.backups.paths = [ "/persist/var/lib/focalboard/" ];
}
