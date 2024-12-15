{ pkgs, lib }:
let
  packagesByName = lib.mapAttrs (
    name: _: pkgs.callPackage (./by-name + "/${name}") { inherit pkgs; }
  ) (builtins.readDir ./by-name);
in
{

}
// packagesByName
