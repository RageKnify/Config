# profiles/server/autoUpgrade.nix
#
# Author: João Borges <RageKnify@gmail.com>
# URL:    https://github.com/RageKnify/Config
#
# autoUpgrade config

{ lib, ... }: {
  system.autoUpgrade = {
    enable = true;
    flake = "github:RageKnify/Config?dir=nix";
    allowReboot = lib.mkDefault true;
    rebootWindow = {
      lower = "03:00";
      upper = "05:00";
    };
  };
}
