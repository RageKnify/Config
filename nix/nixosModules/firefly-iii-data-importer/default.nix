{ moduleWithSystem, ... }:
moduleWithSystem ({ config, ... }:
  { lib, ... }: {
    imports = [ ./module.nix ];
    options.services.firefly-iii-data-importer.package = lib.mkOption {
      type = lib.types.package;
      default = config.packages.firefly-iii-data-importer;
      description = lib.mdDoc
        "Which package to use for the Firefly III data importer instance.";
    };
  })
