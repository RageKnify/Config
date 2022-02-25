# overlays/overrides.nix
#
# Author: João Borges <RageKnify@gmail.com>
# URL:    https://github.com/RageKnify/Config
#
# Overrides nixpkgs. Useful for getting a pkg from latest.

self: super: {
  discord = super.latest.discord;
}
