# modules/system/personal.nix
#
# Author: João Borges <RageKnify@gmail.com>
# URL:    https://github.com/RageKnify/Config
#
# Config for personal machines

{ pkgs, config, lib, user, colors, ... }:
let
  inherit (lib) mkEnableOption mkOption types mkIf;
  cfg = config.modules.personal;
in {
  options.modules.personal = { enable = mkEnableOption "personal"; };

  config = mkIf cfg.enable {
    # to login into Fenix with Kerberos, on Firefox's about:config
    # network.negotiate-auth.trusted-uris	= id.tecnico.ulisboa.pt
    krb5 = {
      enable = true;
      libdefaults = {
        default_realm = "IST.UTL.PT";
        kdc_timesync = 1;
        ccache_type = 4;
        forwardable = true;
        proxiable = true;
      };
      domain_realm = {
        "ist.utl.pt" = "IST.UTL.PT";
        ".ist.utl.pt" = "IST.UTL.PT";
      };
      realms = {
        "IST.UTL.PT" = {
          admin_server = "kerberosmaster.ist.utl.pt";
          #    kdc = [
          #      "athena01.mit.edu"
          #      "athena02.mit.edu"
          #    ];
        };
      };
    };

    # YubiKey stuf
    services.pcscd.enable = true;
    environment.systemPackages = with pkgs; [ yubikey-manager ];

    # Printer stuf
    services.printing.enable = true;
    services.printing.drivers = with pkgs; [ gutenprint gutenprintBin ];

    # SSH stuf
    programs.ssh = { startAgent = true; };
  };
}
