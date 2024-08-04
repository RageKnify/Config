{ config, lib, pkgs, hostSecretsDir, ... }: {
  age.secrets = {
    ritaAuthFile = {
      file = "${hostSecretsDir}/ritaAuthFile.age";
      owner = "nginx";
      group = "nginx";
    };
  };

  services.nginx.virtualHosts."r.jplborges.pt" = {
    forceSSL = true;
    useACMEHost = "jplborges.pt";
    root = "/var/www/r.jplborges.pt/";
    basicAuthFile = config.age.secrets.ritaAuthFile.path;
  };

  networking.firewall.allowedTCPPorts = [ 80 443 ];

  environment.persistence."/persist".directories =
    [ "/var/www/r.jplborges.pt/" ];

  modules.services.backups.paths = [ "/persist/var/www/r.jplborges.pt/" ];
}
