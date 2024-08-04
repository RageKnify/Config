{ pkgs, lib, config, ... }: {
  services.nginx.virtualHosts = {
    "cloud.jborges.eu" = {
      forceSSL = true;
      useACMEHost = "jborges.eu";
      locations."/".proxyPass = "http://conquest.bible.jborges.eu:80";
    };
  };
}
