inputs:
let
  inherit (builtins) listToAttrs concatLists attrValues attrNames readDir;
  inherit (inputs.nixpkgs) lib;
  inherit (lib) mapAttrs mapAttrsToList hasSuffix;
  sshKeys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIC2sdJFvvnEIYztPcznXvKpY4vOWedZ1qzDaAgRxrczS jp@war"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAII9ckbhT0em/dL75+RV+sdqwbprRC9Ff/MoqqpBgbUSh jp@pestilence"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIO8F6mLnoZq/Z1nnLiWPs0f6MlPN4AS7HmwmuheDebxS jp@famine"
  ];
  colors = import ./colors.nix { };
  hostNameToColor = hostName:
    let
      mapping = {
        war = "base08";
        death = "base0A";
        lazarus = "base09";
        cain = "base0C";
        azazel = "base0E";
      };
      base = mapping."${hostName}";
    in colors.light."${base}";

  system = "x86_64-linux";
  user = "jp";

  pkg-sets = final: prev:
    let
      args = {
        system = final.system;
        config.allowUnfree = true;
      };
    in {
      unstable = import inputs.nixpkgs-unstable args;
      latest = import inputs.nixpkgs-latest args;
    };

  secretsDir = ./secrets;

  overlaysDir = ./overlays;

  myOverlays = mapAttrsToList
    (name: _: import "${overlaysDir}/${name}" { inherit inputs; })
    (readDir overlaysDir);

  overlays = [ inputs.agenix.overlays.default pkg-sets ] ++ myOverlays;

  pkgs = import inputs.nixpkgs {
    inherit system overlays;
    config.allowUnfree = true;
  };

  systemModules = mkModules ./modules/system;
  homeModules = mkModules ./modules/home;

  mkModules = dir:
    concatLists (attrValues (inputs.digga.lib.importExportableModules dir));

  profiles = inputs.digga.lib.rakeLeaves ./profiles;

  # Imports every host defined in a directory.
  mkHosts = dir:
    listToAttrs (map (name: {
      inherit name;
      value = inputs.nixpkgs.lib.nixosSystem {
        inherit system pkgs;
        specialArgs = {
          inherit inputs user colors sshKeys profiles;
          hostSecretsDir = "${secretsDir}/${name}";
        };
        modules = [
          { networking.hostName = name; }
          (dir + "/${name}")
          inputs.home.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              extraSpecialArgs = {
                inherit colors;
                hostColor = hostNameToColor name;
              };
              sharedModules = homeModules;
            };
          }
          inputs.impermanence.nixosModules.impermanence
          inputs.agenix.nixosModules.age
          inputs.lanzaboote.nixosModules.lanzaboote
          inputs.simple-nixos-mailserver.nixosModule
        ] ++ systemModules;
      };
    }) (attrNames (readDir dir)));
in { nixosConfigurations = mkHosts ./hosts; }
