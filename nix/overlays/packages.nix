# overlays/packages.nix
#
# Author: João Borges <RageKnify@gmail.com>
# URL:    https://github.com/RageKnify/Config
#
# Extra packages. (none for now, based on RiscadoA's)

{ packageDir, ... }: final: prev: rec {
  # Need to use nss_latest like Firefox for hyperlinks to work
  discord = prev.discord.override {
    nss = final.nss_latest;
  };
}
