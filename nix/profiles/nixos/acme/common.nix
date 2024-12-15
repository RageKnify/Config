{
  pkgs,
  lib,
  hostSecretsDir,
  ...
}:
{
  security.acme = {
    acceptTerms = true;
    defaults.email = "letsencrypt@jborges.eu";
  };

  environment.persistence."/persist".directories = [
    {
      directory = "/var/lib/acme";
      user = "acme";
      group = "acme";
    }
  ];

  modules.services.backups.paths = [ "/persist/var/lib/acme/" ];
}
