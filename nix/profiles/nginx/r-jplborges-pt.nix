{ config, lib, pkgs, ... }: {
  services.nginx.virtualHosts = {
    "r.jplborges.pt" = {
      forceSSL = true;
      enableACME = true;
      root = "/var/www/r.jplborges.pt/";
    };
  };

  networking.firewall.allowedTCPPorts = [ 80 443 ];

  environment.persistence."/persist".directories = [ "/var/www/r.jplborges.pt/" ];
}
