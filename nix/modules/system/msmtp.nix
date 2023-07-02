{ config, lib, pkgs, hostSecretsDir, ... }:
let
  inherit (lib) mkEnableOption mkOption types mkIf;
  cfg = config.modules.msmtp;
  hostName = config.networking.hostName;
in {
  options.modules.msmtp = { enable = mkEnableOption "backups"; };
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
        user = "${hostName}@jborges.eu";
        host = "mail.jborges.eu";
        passwordeval = "cat ${config.age.secrets.hostMailPassword.path}";
      };
    };
  };
}
