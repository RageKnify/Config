# profiles/server/nix-gc.nix
#
# Author: João Borges <RageKnify@gmail.com>
# URL:    https://github.com/RageKnify/Config
#
# gc config

{ ... }: {
  nix.gc = {
    automatic = true;
    dates = "weekly";
    randomizedDelaySec = "60min";
  };
}
