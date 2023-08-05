{ config, lib, pkgs, ... }: {
  services.fail2ban = {
    enable = true;
    maxretry = 5;
    bantime-increment = {
      enable = true;
      rndtime = "5min";
      maxtime = "24h";
    };
  };

  environment.persistence."/persist".directories =
    [{ directory = "/var/lib/fail2ban"; }];
}
