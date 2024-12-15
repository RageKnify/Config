# modules/system/laptop.nix
#
# Author: João Borges <RageKnify@gmail.com>
# URL:    https://github.com/RageKnify/Config
#
# laptop configurations

{
  pkgs,
  config,
  lib,
  profiles,
  ...
}:
let
  inherit (lib)
    mkEnableOption
    mkOption
    types
    mkIf
    ;
  cfg = config.modules.laptop;
in
{
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

    adapter = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = lib.mdDoc ''
        The identifier of the laptop's adapter, used by
        other modules like polybar.
      '';
      example = [ "ADP1" ];
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
  config = mkIf cfg.enable {
    # laptop implies personal machine
    modules.personal.enable = true;
    # laptop implies physical machine
    modules.physical.enable = true;

    services.libinput = {
      enable = true;
      touchpad.naturalScrolling = true;
    };

    programs.light.enable = true;

    programs.nm-applet.enable = true;
  };
}
