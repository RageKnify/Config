{ config, lib, pkgs, ... }:
let
  domain = "wallabag.jplborges.pt";
  port = "2300";
in {
  services.nginx.virtualHosts.${domain} = {
    forceSSL = true;
    useACMEHost = "jplborges.pt";
    locations."/".proxyPass = "http://127.0.0.1:${port}";
  };

  virtualisation.oci-containers.containers.wallabag = {
    image = "wallabag/wallabag:2.5.4";
    ports = [ "127.0.0.1:${port}:80" ];
    volumes = [
      "/var/lib/wallabag/data:/var/www/wallabag/data"
      "/var/lib/wallabag/images:/var/www/wallabag/web/assets/images"
    ];
    environment = {
      SYMFONY__ENV__FOSUSER_REGISTRATION = "false";
      SYMFONY__ENV__DOMAIN_NAME = "https://${domain}";
    };
  };

  environment.persistence."/persist".directories = [ "/var/lib/wallabag" ];
}
