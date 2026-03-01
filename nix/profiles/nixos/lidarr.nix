{
  pkgs,
  lib,
  config,
  hostSecretsDir,
  ...
}:
{
  services.lidarr = {
    enable = true;

    openFirewall = true;

    settings = {
      server = {
        bindaddress = "127.0.0.1";
      };
    };
  };

  users.groups.media = {};

  users.users = {
    ${config.services.lidarr.user}.extraGroups = [
      "media"
      config.services.transmission.group
    ];
  };

  services.nginx.virtualHosts = {
    "lidarr.bible.jborges.eu" = {
      forceSSL = true;
      useACMEHost = "bible.jborges.eu";
      locations."/".proxyPass =
        "http://localhost:${builtins.toString config.services.lidarr.settings.server.port}";
      extraConfig = ''
        allow 100.64.0.0/24;
        deny all;
      '';
    };
  };

  environment.persistence."/persist".directories = [
    {
      directory = config.services.lidarr.dataDir;
      user = config.services.lidarr.user;
      group = config.services.lidarr.group;
    }
    {
      directory = "/media";
      user = "root";
      group = "media";
    }
  ];

  modules.services.backups.paths = [
    "/persist${config.services.lidarr.dataDir}"
    "/persist/media"
  ];
}
