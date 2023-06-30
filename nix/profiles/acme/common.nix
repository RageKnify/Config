{ inputs, pkgs, lib, hostSecretsDir, ... }: {
  security.acme = {
    acceptTerms = true;
    defaults.email = "letsencrypt@jborges.eu";
  };

  environment.persistence."/persist".directories = [ "/var/lib/acme" ];
}
