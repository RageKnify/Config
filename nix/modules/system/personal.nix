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
    # YubiKey stuf
    services.pcscd.enable = true;
    environment.systemPackages = with pkgs; [
      yubikey-manager
      # qmk stuf
      qmk
    ];
    hardware.keyboard.qmk.enable = true;

    # Printer stuf
    services.printing.enable = true;
    services.printing.drivers = with pkgs; [ gutenprint gutenprintBin ];

    # SSH stuf
    programs.ssh = {
      startAgent = true;
      agentTimeout = "30m";
    };
  };
}
