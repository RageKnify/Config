{ pkgs, fetchFromGitHub, phpPackage ? pkgs.php83, ... }:
let version = "1.4.4";
in phpPackage.buildComposerProject (finalAttrs: {
  inherit version;
  pname = "firefly-iii-data-importer";

  src = fetchFromGitHub {
    owner = "firefly-iii";
    repo = "data-importer";
    rev = "v${version}";
    hash = "sha256-hR17EL/4XdT5aewdKx+5ytSjWUGFKxh3Ht0qghWolTQ=";
  };
  vendorHash = "sha256-oVLA1uhhDzPuNqaNtnjijFM0cx2jrRSbY0ptfjkhBIU=";

  # they have some version constraints that are frowned upon apparently
  composerStrictValidation = false;

  patches = [ ./firefly-storage-path.patch ./firefly-sendmail-path.patch ];
})
