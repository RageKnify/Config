{
  config,
  lib,
  pkgs,
  hostSecretsDir,
  ...
}:
{
  age.secrets.cloudflare = {
    file = "${hostSecretsDir}/cloudflare.age";
    owner = "acme";
    group = "acme";
  };

  # Use services.nginx.virtualHosts."example.jborges.eu".useACMEHost = "jborges.eu";
  # to use the wildcard certificate on subdomains.
  security.acme.certs."jborges.eu" = {
    domain = "jborges.eu";
    extraDomainNames = [ "*.jborges.eu" ];
    dnsProvider = "cloudflare";
    dnsPropagationCheck = true;
    credentialsFile = config.age.secrets.cloudflare.path;
  };

  users.users.nginx.extraGroups = [ "acme" ];
}
