{ moduleWithSystem, ... }:
moduleWithSystem ({ config, ... }:
  { lib, ... }: {
    imports = [ ./module.nix ];
    options.services.my-firefly-iii-data-importer.package = lib.mkOption {
      type = lib.types.package;
      default = config.packages.my-firefly-iii-data-importer;
      description = lib.mdDoc
        "Which package to use for the Firefly III data importer instance.";
    };
  })
