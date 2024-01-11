{ pkgs, fetchFromGitHub, phpPackage ? pkgs.php83, ... }:
let version = "1.4.0";
in phpPackage.buildComposerProject (finalAttrs: {
  inherit version;
  pname = "firefly-iii-data-importer";

  src = fetchFromGitHub {
    owner = "firefly-iii";
    repo = "data-importer";
    rev = "v${version}";
    hash = "sha256-tXHj0QsIywiGfm4nEPw6auM0Bw8NoCJdDTH7R59Krjc=";
  };
  vendorHash = "sha256-dziaNdbWAYivH6WBUD5ePfJNK+3VWiNjrlgBoCliVeE=";

  # they have some version constraints that are frowned upon apparently
  composerStrictValidation = false;

  patches = [ ./firefly-storage-path.patch ./firefly-sendmail-path.patch ];
})
