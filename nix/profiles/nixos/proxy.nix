{
  pkgs,
  lib,
  config,
  ...
}:
{
  services.nginx.virtualHosts = {
    "cloud.jborges.eu" = {
      forceSSL = true;
      useACMEHost = "jborges.eu";
      locations."/".proxyPass = "http://100.64.0.2:80"; # conquest.bible
    };
    "music.jborges.eu" = {
      forceSSL = true;
      useACMEHost = "jborges.eu";
      locations."/".proxyPass = "https://100.64.0.2:443"; # conquest.bible
    };
  };
}
