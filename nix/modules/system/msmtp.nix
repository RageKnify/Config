{
  config,
  lib,
  pkgs,
  hostSecretsDir,
  ...
}:
let
  inherit (lib)
    mkEnableOption
    mkOption
    types
    mkIf
    ;
  cfg = config.modules.msmtp;
  hostName = config.networking.hostName;
in
{
  options.modules.msmtp = {
    enable = mkEnableOption "msmtp";
  };
  config = mkIf cfg.enable {

    age.secrets.hostMailPassword = {
      mode = "444";
      file = "${hostSecretsDir}/${hostName}MailPassword.age";
    };

    programs.msmtp = {
      enable = true;
      defaults = {
        port = 587;
        tls = true;
      };
      accounts.default = {
        auth = true;
        aliases = "/etc/aliases";
        user = "${hostName}@jborges.eu";
        from = "${hostName} <${hostName}@jborges.eu>";
        host = "mail.jborges.eu";
        passwordeval = "${pkgs.coreutils}/bin/cat ${config.age.secrets.hostMailPassword.path}";
      };
      setSendmail = true;
    };

    #Aliases to receive root mail
    environment.etc."aliases".text = ''
      root: me+robots@jborges.eu
      jp: me+robots@jborges.eu
    '';
  };
}
