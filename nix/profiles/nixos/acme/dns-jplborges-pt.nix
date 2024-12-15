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

  # Use services.nginx.virtualHosts."example.jplborges.pt".useACMEHost = "jplborges.pt";
  # to use the wildcard certificate on subdomains.
  security.acme.certs."jplborges.pt" = {
    domain = "jplborges.pt";
    extraDomainNames = [ "*.jplborges.pt" ];
    dnsProvider = "ovh";
    webroot = null; # something was setting this, conflicting with dnsProvider
    dnsPropagationCheck = true;
    credentialsFile = config.age.secrets.ovh.path;
  };

  users.users.nginx.extraGroups = [ "acme" ];
}
