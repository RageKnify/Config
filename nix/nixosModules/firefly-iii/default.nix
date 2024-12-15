{ moduleWithSystem, ... }:
moduleWithSystem (
  { config, ... }:
  { lib, ... }:
  {
    imports = [ ./module.nix ];
    options.services.myfirefly-iii.package = lib.mkOption {
      type = lib.types.package;
      default = config.packages.myfirefly-iii;
      description = lib.mdDoc "Which package to use for the Firefly III instance.";
    };
  }
)
