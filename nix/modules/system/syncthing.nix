# modules/system/syncthing.nix
#
# Author: João Borges <RageKnify@gmail.com>
# URL:    https://github.com/RageKnify/Config
#
# syncthing configuration

{ pkgs, config, lib, utils, user, ... }:
let
  inherit (lib) mkEnableOption mkOption types mkIf;
  cfg = config.modules.syncthing;
in {
  options.modules.syncthing.enable = mkEnableOption "syncthing";

  config = mkIf cfg.enable {
    services.syncthing = {
      inherit user;
      enable = true;
      systemService = true;
      dataDir = "/home/${user}/.syncthing";
      overrideFolders = false;
      overrideDevices = false;
      extraOptions = { gui = { theme = "dark"; }; };
    };
  };
}

