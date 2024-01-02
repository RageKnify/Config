# modules/system/physical.nix
#
# Author: João Borges <RageKnify@gmail.com>
# URL:    https://github.com/RageKnify/Config
#
# physical machine configurations

{ pkgs, config, lib, ... }:
let
  inherit (lib) mkEnableOption mkOption types mkIf;
  cfg = config.modules.physical;
  hostName = config.networking.hostName;
in {
  options.modules.physical = { enable = mkEnableOption "physical"; };
  config = mkIf cfg.enable {
    #Enable SMARTd
    services.smartd = {
      enable = true;
      autodetect = true;
      notifications = {
        mail = {
          sender = "${hostName}@jborges.eu";
          recipient = "me+robots@jborges.eu";
        };
      };
    };
  };
}
