# hosts/system.nix
#
# Author: João Borges <RageKnify@gmail.com>
# URL:    https://github.com/RageKnify/Config
#
# Kerberos config

{ inputs, pkgs, lib, ... }: {
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
      "IST.UTL.PT" = { admin_server = "kerberosmaster.ist.utl.pt"; };
    };
  };

  programs.firefox.preferences."network.negotiate-auth.trusted-uris" =
    "id.tecnico.ulisboa.pt";
}
