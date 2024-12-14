{ pkgs, lib, config, hostSecretsDir, ... }: {
  age.secrets.firefly-data-importer-secrets = {
    file = "${hostSecretsDir}/firefly-data-importer-secrets.age";
    owner = "firefly-iii-data-importer";
    group = "firefly-iii-data-importer";
  };

  services.my-firefly-iii-data-importer = {
    enable = true;

    hostName = "ff3di.jborges.eu";

    https = true;

    fireflyUrl = "https://ff3.jborges.eu";

    reportsAddr = "me+robots@jborges.eu";

    environmentFile = config.age.secrets.firefly-data-importer-secrets.path;
  };

  services.nginx.virtualHosts = {
    "${config.services.my-firefly-iii-data-importer.hostName}" = {
      forceSSL = true;
      useACMEHost = "jborges.eu";
    };
  };

  environment.persistence."/persist".directories = [{
    directory = config.services.my-firefly-iii-data-importer.home;
    user = "firefly-iii-data-importer";
    group = "firefly-iii-data-importer";
  }];

  modules.services.backups.paths =
    [ "/persist/${config.services.my-firefly-iii-data-importer.home}/" ];
}
