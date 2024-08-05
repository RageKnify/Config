inputs:
let
  inherit (builtins)
    listToAttrs
    concatLists
    attrValues
    attrNames
    readDir
    ;
  inherit (inputs.nixpkgs) lib;
  inherit (lib) mapAttrs hasSuffix;
  inherit (import ./lib { inherit lib; }) myLib;
  inherit (inputs) moduleWithSystem flake-parts-lib;
  inherit (flake-parts-lib) importApply;
  sshKeys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIC2sdJFvvnEIYztPcznXvKpY4vOWedZ1qzDaAgRxrczS jp@war"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAII9ckbhT0em/dL75+RV+sdqwbprRC9Ff/MoqqpBgbUSh jp@pestilence"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIO8F6mLnoZq/Z1nnLiWPs0f6MlPN4AS7HmwmuheDebxS jp@famine"
  ];

  pkg-sets =
    final: prev:
    let
      args = {
        system = final.system;
        config.allowUnfree = true;
      };
    in
    {
      unstable = import inputs.nixpkgs-unstable args;
      latest = import inputs.nixpkgs-latest args;
      mypkgs = inputs.self.outputs.packages.${final.system};
    };

  secretsDir = ./secrets;

  overlaysDir = ./overlays;

  myOverlays = mapAttrs (name: _: import "${overlaysDir}/${name}" { inherit inputs; }) (
    readDir overlaysDir
  );

  overlays = [
    inputs.agenix.overlays.default
    pkg-sets
  ] ++ attrValues myOverlays;

  systemModules = myLib.listModulesRecursive ./modules/system;
  homeModules = myLib.listModulesRecursive ./modules/home;

  profiles = myLib.rakeLeaves ./profiles;

  # Imports every host defined in a directory.
  mkHosts =
    dir:
    listToAttrs (
      map (name: {
        inherit name;
        value = lib.nixosSystem {
          specialArgs = {
            inherit
              inputs
              sshKeys
              profiles
              myLib
              nixosConfigurations
              ;
            hostSecretsDir = "${secretsDir}/${name}";
          };
          modules =
            [
              { networking.hostName = name; }
              (dir + "/${name}")
              {
                nixpkgs = {
                  inherit overlays;
                  config = {
                    allowUnfree = true;
                  };
                };
              }
              inputs.home.nixosModules.home-manager
              {
                home-manager = {
                  useGlobalPkgs = true;
                  useUserPackages = true;
                  extraSpecialArgs = { inherit myLib; };
                  sharedModules = homeModules;
                };
              }
              inputs.impermanence.nixosModules.impermanence
              inputs.agenix.nixosModules.age
              inputs.lanzaboote.nixosModules.lanzaboote
              inputs.simple-nixos-mailserver.nixosModule
              inputs.disko.nixosModules.disko
            ]
            ++ systemModules
            ++ (attrValues nixosModules);
        };
      }) (attrNames (readDir dir))
    );

  nixosConfigurations = mkHosts ./hosts;

  nixosModules = lib.mapAttrs (
    name: _: importApply (./nixosModules + "/${name}") { inherit moduleWithSystem; }
  ) (builtins.readDir ./nixosModules);
in
{
  inherit nixosConfigurations nixosModules;
  overlays = myOverlays;
  homeConfigurations."jborges" = inputs.home.lib.homeManagerConfiguration {
    pkgs = inputs.nixpkgs.legacyPackages."x86_64-linux";
    modules = [
      ./death-home.nix
      {
      	nixpkgs.overlays = attrValues myOverlays;
      }
    ];
    extraSpecialArgs = {
      inherit myLib;
      osConfig = {
        modules.personal.enable = true;
        modules.laptop.enable = false;
        programs.light.enable = false;
        networking.hostName = "death";
      };
    };
  };
}
