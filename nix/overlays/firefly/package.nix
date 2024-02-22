{ pkgs, fetchFromGitHub, phpPackage ? pkgs.php83, ... }:
let version = "6.1.9";
in phpPackage.buildComposerProject (finalAttrs: {
  inherit version;
  pname = "firefly-iii";

  src = fetchFromGitHub {
    owner = "firefly-iii";
    repo = "firefly-iii";
    rev = "v${version}";
    hash = "sha256-2KgQcatheAbFbs72PHjPpnBMWMzXxTtGatZQ9zIAuGw=";
  };
  vendorHash = "sha256-vbc9QCwniCY4gvSXy/avIGAVD9dMXh4Ou23i7hgob6Y=";

  patches = [ ./firefly-storage-path.patch ];
})
