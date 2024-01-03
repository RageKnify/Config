# overlays/firefly/default.nix
#
# Author: João Borges <RageKnify@gmail.com>
# URL:    https://github.com/RageKnify/Config
#
# Have access to Firefly 3

{ ... }:
final: prev: rec {
  firefly-iii = prev.callPackage
    ({ pkgs, fetchFromGitHub, phpPackage ? pkgs.php83, ... }:
      let version = "6.1.1";
      in phpPackage.buildComposerProject (finalAttrs: {
        inherit version;
        pname = "firefly-iii";

        src = fetchFromGitHub {
          owner = "firefly-iii";
          repo = "firefly-iii";
          rev = "v${version}";
          hash = "sha256-pcT1Ls5fwmv5nMqFpMksl8drvlRWmBv7+xm6f++H1Qw=";
        };
        vendorHash = "sha256-dsVV91HRyaWjMGXcrSUlOtdAJSfGV8BjAZb22j/ws/A=";

        patches = [ ./firefly-storage-path.patch ];
      })) { };
}
