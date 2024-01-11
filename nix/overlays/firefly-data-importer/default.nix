# overlays/firefly-data-importer/default.nix
#
# Author: João Borges <RageKnify@gmail.com>
# URL:    https://github.com/RageKnify/Config
#
# Have access to Firefly 3 Data Importer

{ ... }:
final: prev: rec {
  firefly-iii-data-importer = prev.callPackage ./package.nix { };
}
