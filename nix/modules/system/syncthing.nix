# modules/system/syncthing.nix
#
# Author: João Borges <RageKnify@gmail.com>
# URL:    https://github.com/RageKnify/Config
#
# syncthing configuration

{ pkgs, lib, options, config, ... }:
let
  inherit (lib) mkEnableOption mkOption types mkIf;
  cfg = config.modules.syncthing;
in {
  options.modules.syncthing = {
    enable = mkEnableOption "syncthing";
    user = options.services.syncthing.user;
  };

  config = let
    serviceUser = cfg.user == "syncthing";
    dataDir = if serviceUser then
      options.services.syncthing.dataDir.default
    else
      "/home/${cfg.user}/.syncthing";
  in mkIf cfg.enable {
    services.syncthing = {
      enable = true;
      user = cfg.user;
      systemService = true;
      inherit dataDir;
      overrideFolders = false;
      overrideDevices = false;
      extraOptions = { gui = { theme = "dark"; }; };
    };
    environment.persistence."/persist".directories =
      mkIf serviceUser [ "${config.services.syncthing.dataDir}" ];
  };
}

