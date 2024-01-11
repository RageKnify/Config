# overlays/firefly/default.nix
#
# Author: João Borges <RageKnify@gmail.com>
# URL:    https://github.com/RageKnify/Config
#
# Have access to Firefly 3

{ ... }:
final: prev: rec {
  firefly-iii = prev.callPackage ./package.nix { };
}
