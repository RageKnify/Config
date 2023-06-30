{ config, lib, pkgs, ... }: {
  services.nginx.virtualHosts = {
    "jplborges.pt" = {
      forceSSL = true;
      enableACME = true;
      globalRedirect = "jborges.eu";
    };

    "jborges.eu" = {
      forceSSL = true;
      useACMEHost = "jborges.eu";
      root = "/var/www/jborges.eu/";
    };
  };

  networking.firewall.allowedTCPPorts = [ 80 443 ];

  environment.persistence."/persist".directories = [ "/var/www/jborges.eu/" ];
}
