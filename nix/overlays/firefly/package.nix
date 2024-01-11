{ pkgs, fetchFromGitHub, phpPackage ? pkgs.php83, ... }:
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
})
