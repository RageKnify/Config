{ pkgs, fetchFromGitHub, phpPackage ? pkgs.php83, ... }:
let version = "6.1.10";
in phpPackage.buildComposerProject (finalAttrs: {
  inherit version;
  pname = "firefly-iii";

  src = fetchFromGitHub {
    owner = "firefly-iii";
    repo = "firefly-iii";
    rev = "v${version}";
    hash = "sha256-RPkSX9o/5XGh1dZhyyFYsPedl6/SHOGXOAY2/x7aiaM=";
  };
  vendorHash = "sha256-BQThhJwMdjs2d1iQpKU+19qU2NFmzMTW8d28KCAxKqc=";

  patches = [ ./firefly-storage-path.patch ];
})
