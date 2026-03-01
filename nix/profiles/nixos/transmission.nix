{
  pkgs,
  lib,
  config,
  hostSecretsDir,
  ...
}:
let
  domain = "transmission.bible.jborges.eu";
in
{
  services.transmission = {
    enable = true;

    package = pkgs.transmission_4;

    openFirewall = true;

    settings.rpc-host-whitelist = domain;
  };

  services.nginx.virtualHosts = {
    domain = {
      forceSSL = true;
      useACMEHost = "bible.jborges.eu";
      locations."/".proxyPass =
        "http://localhost:${builtins.toString config.services.transmission.settings.rpc-port}";
      extraConfig = ''
        allow 100.64.0.0/24;
        deny all;
      '';
    };
  };

  environment.persistence."/persist".directories = [
    {
      directory = config.services.transmission.home;
      user = config.services.transmission.user;
      group = config.services.transmission.group;
    }
  ];

  modules.services.backups.paths = [
    "/persist${config.services.transmission.home}"
  ];
}
