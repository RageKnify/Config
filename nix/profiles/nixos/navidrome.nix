{
  pkgs,
  lib,
  config,
  hostSecretsDir,
  ...
}:
let
  socketPath = "unix:/run/navidrome/navidrome.sock";
in
{
  services.navidrome = {
    enable = true;

    settings = {
      Address = socketPath;
      MusicFolder = "/var/lib/nextcloud/data/jp/files/music";
    };
  };

  services.nginx.virtualHosts = {
    "music.jborges.eu" = {
      forceSSL = true;
      useACMEHost = "jborges.eu";
      locations."/".proxyPass = "http://${socketPath}";
    };
  };

  users.groups.navidrome.members = [ "nginx" ];

  environment.persistence."/persist".directories = [
    {
      directory = "/var/lib/navidrome";
      user = "navidrome";
      group = "navidrome";
    }
  ];

  modules.services.backups.paths = [ "/persist/var/lib/navidrome/" ];
}
