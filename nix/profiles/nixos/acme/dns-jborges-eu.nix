{
  config,
  lib,
  pkgs,
  hostSecretsDir,
  ...
}:
{
  age.secrets.ovh = {
    file = "${hostSecretsDir}/ovh.age";
    owner = "acme";
    group = "acme";
  };

  # Use services.nginx.virtualHosts."example.jborges.eu".useACMEHost = "jborges.eu";
  # to use the wildcard certificate on subdomains.
  security.acme.certs."jborges.eu" = {
    domain = "jborges.eu";
    extraDomainNames = [ "*.jborges.eu" ];
    dnsProvider = "ovh";
    dnsPropagationCheck = true;
    credentialsFile = config.age.secrets.ovh.path;
  };

  users.users.nginx.extraGroups = [ "acme" ];
}
