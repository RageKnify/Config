# modules/system/laptop.nix
#
# Author: João Borges <RageKnify@gmail.com>
# URL:    https://github.com/RageKnify/Config
#
# laptop configurations

{ pkgs, config, lib, profiles, ... }:
let
  inherit (lib) mkEnableOption mkOption types mkIf;
  cfg = config.modules.laptop;
in {
  options.modules.laptop = {
    enable = mkEnableOption "laptop";

    battery = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = lib.mdDoc ''
        The identifier of the laptop's battery, used by
        other modules like polybar.
      '';
      example = [ "BAT0" ];
    };
    wlan_interface = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = lib.mdDoc ''
        The identifier of the laptop's wireless interface,
        used by other modules like polybar.
      '';
      example = [ "wlp2s0" ];
    };
  };
}
