# overlays/zfs.nix
#
# Author: João Borges <RageKnify@gmail.com>
# URL:    https://github.com/RageKnify/Config
#
# Enable email support

{ ... }:
final: prev: rec {
  zfs = prev.zfs.override { enableMail = true; };
}
