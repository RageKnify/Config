{
  pkgs,
  lib,
  config,
  hostSecretsDir,
  ...
}:
{
  age.secrets.mailJoaoHashedPassword.file = "${hostSecretsDir}/mailJoaoHashedPassword.age";
  age.secrets.mailAzazelHashedPassword.file = "${hostSecretsDir}/mailAzazelHashedPassword.age";
  age.secrets.mailConquestHashedPassword.file = "${hostSecretsDir}/mailConquestHashedPassword.age";
  age.secrets.mailWarHashedPassword.file = "${hostSecretsDir}/mailWarHashedPassword.age";

  imports = [ ];

  mailserver = {
    enable = true;
    fqdn = "mail.jborges.eu";

    domains = [
      "jborges.eu"
      "jplborges.pt"
    ];

    enableManageSieve = true;

    localDnsResolver = false;

    loginAccounts = {
      "me@jborges.eu" = {
        hashedPasswordFile = config.age.secrets.mailJoaoHashedPassword.path;

        aliases = [ "@jborges.eu" ];
      };
      "azazel@jborges.eu" = {
        hashedPasswordFile = config.age.secrets.mailAzazelHashedPassword.path;
        sendOnly = true;
      };
      "conquest@jborges.eu" = {
        hashedPasswordFile = config.age.secrets.mailConquestHashedPassword.path;
        sendOnly = true;
      };
      "war@jborges.eu" = {
        hashedPasswordFile = config.age.secrets.mailWarHashedPassword.path;
        sendOnly = true;
      };
    };

    mailboxes = {
      Archive = {
        auto = "subscribe";
        specialUse = "Archive";
      };
      Drafts = {
        auto = "subscribe";
        specialUse = "Drafts";
      };
      Sent = {
        auto = "subscribe";
        specialUse = "Sent";
      };
      Junk = {
        auto = "subscribe";
        specialUse = "Junk";
      };
      Trash = {
        auto = "no";
        specialUse = "Trash";
      };
    };

    certificateScheme = "acme";

    stateVersion = 3;
  };

  # we want to use msmtp instead
  services.postfix.setSendmail = false;

  security.acme.certs."mail.jborges.eu" = {
    dnsProvider = "cloudflare";
    dnsPropagationCheck = true;
    credentialsFile = config.age.secrets.cloudflare.path;
  };

  environment.persistence."/persist".directories = [
    "/var/lib/rspamd"
    {
      directory = "/var/vmail";
      user = "virtualMail";
      group = "virtualMail";
    }
    {
      directory = "/var/dkim";
      user = "opendkim";
      group = "opendkim";
    }
    {
      directory = "/var/sieve";
      user = "virtualMail";
      group = "virtualMail";
    }
  ];

  modules.services.backups.paths = [
    "/persist/var/lib/rspamd/"
    "/persist/var/vmail/"
    "/persist/var/dkim/"
    "/persist/var/sieve"
  ];
}
