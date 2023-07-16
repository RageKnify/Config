{ config, lib, pkgs, ... }:
let
  domain = "focalboard.jplborges.pt";
  port = "2301";
  server_config = (pkgs.writeText "server_config.json" (''
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
  ''));
in {
  services.nginx.virtualHosts.${domain} = {
    forceSSL = true;
    useACMEHost = "jplborges.pt";
    locations."/" = {
      proxyWebsockets = true;
      proxyPass = "http://127.0.0.1:${port}";
    };
  };

  virtualisation.oci-containers.containers.focalboard = {
    image = "mattermost/focalboard:7.10.4";
    ports = [ "127.0.0.1:${port}:8000" ];
    volumes = [
      "${server_config}:/opt/focalboard/config.json:ro,Z"
      "/var/lib/focalboard/:/data/"
    ];
    user = "1000:100";
  };

  environment.persistence."/persist".directories = [ "/var/lib/focalboard" ];

  modules.services.backups.paths = [
    "/persist/var/lib/focalboard/"
  ];
}
