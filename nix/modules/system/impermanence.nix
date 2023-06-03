# modules/system/impermanence.nix
#
# Author: João Borges <RageKnify@gmail.com>
# URL:    https://github.com/RageKnify/Config
#
# root as tmpfs configuration.

{ lib, config, pkgs, ... }:
let
  inherit (lib) mkEnableOption mkOption mkIf;
  cfg = config.modules.impermanence;
in {
  options.modules.impermanence.enable = mkEnableOption "impermanence";

  config = mkIf cfg.enable {
    # Persistent files
    environment.persistence."/persist" = {
      directories = [
        "/etc/NetworkManager/system-connections"
        "/var/lib/docker"
        "/var/lib/libvirt"
        "/var/lib/sddm"
        "/var/log"
      ];
      files = [ "/etc/machine-id" ];
    };

    fileSystems."/persist".neededForBoot = true;
  };
}
