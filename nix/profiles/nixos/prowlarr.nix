{
  pkgs,
  lib,
  config,
  hostSecretsDir,
  ...
}:
{
  services.prowlarr = {
    enable = true;

    openFirewall = true;

    settings = {
      server = {
        bindaddress = "127.0.0.1";
      };
    };
  };

  services.nginx.virtualHosts = {
    "prowlarr.bible.jborges.eu" = {
      forceSSL = true;
      useACMEHost = "bible.jborges.eu";
      locations."/".proxyPass = "http://localhost:${
        builtins.toString config.services.prowlarr.settings.server.port
      }";
      extraConfig = ''
        allow 100.64.0.0/24;
        deny all;
      '';
    };
  };

  environment.persistence."/persist".directories = [
    "/var/lib/private/prowlarr"
  ];

  modules.services.backups.paths = [
    "/persist/var/lib/private/prowlarr"
  ];
}
