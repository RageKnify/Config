{ inputs, pkgs, lib, config, hostSecretsDir, ... }: {
  age.secrets.mailJoaoHashedPassword.file =
    "${hostSecretsDir}/mailJoaoHashedPassword.age";

  imports = [
    inputs.simple-nixos-mailserver.nixosModule
    {
      mailserver = {
        enable = true;
        fqdn = "mail.jborges.eu";

        domains = [ "jborges.eu" "jplborges.pt" ];

        loginAccounts = {
          "me@jborges.eu" = {
            hashedPasswordFile = config.age.secrets.mailJoaoHashedPassword.path;

            aliases = [ "@jborges.eu" ];
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
      };
    }
  ];

  security.acme.certs."mail.jborges.eu" = {
    dnsProvider = "ovh";
    dnsPropagationCheck = true;
    credentialsFile = config.age.secrets.ovh.path;
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
  ];
}