# overlays/python.nix
#
# Author: João Borges <RageKnify@gmail.com>
# URL:    https://github.com/RageKnify/Config
#
# python with usefull modules

{ ... }:
final: prev: rec {
  my_python =
    let
      usefull_modules = p: [
        p.pandas
        p.pwntools
        p.requests
        p.numpy
      ];
    in
    prev.python3.withPackages usefull_modules;
}
