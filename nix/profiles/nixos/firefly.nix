{ pkgs, lib, config, hostSecretsDir, ... }: {
  age.secrets.firefly-secrets = {
    file = "${hostSecretsDir}/firefly-secrets.age";
    owner = "firefly-iii";
    group = "firefly-iii";
  };

  services.myfirefly-iii = {
    enable = true;

    hostName = "ff3.jborges.eu";

    https = true;

    adminAddr = "me+robots@jborges.eu";

    database.createLocally = true;

    config.dbtype = "pgsql";

    environmentFile = config.age.secrets.firefly-secrets.path;
  };

  services.nginx.virtualHosts = {
    "${config.services.myfirefly-iii.hostName}" = {
      forceSSL = true;
      useACMEHost = "jborges.eu";
    };
  };

  environment.persistence."/persist".directories = [{
    directory = config.services.myfirefly-iii.home;
    user = "firefly-iii";
    group = "firefly-iii";
  }];

  modules.services.backups.paths =
    [ "/persist/${config.services.myfirefly-iii.home}/" ];
}
