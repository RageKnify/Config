# flake.nix
#
# Author: João Borges <RageKnify@gmail.com>
# URL:    https://github.com/RageKnify/Config
#
# My config, based on RiscadoA's

{
  description = "Nix configuration for PCs and servers.";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-latest.url = "github:nixos/nixpkgs/master";
    flake-utils.url = "github:numtide/flake-utils";
    impermanence.url = "github:nix-community/impermanence/master";
    home = {
      url = "github:nix-community/home-manager/release-23.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    obsidian-nvim = {
      url = "github:epwalsh/obsidian.nvim/main";
      flake = false;
    };
    agenix = {
      url = "github:ryantm/agenix/main";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    digga = {
      url = "github:divnix/digga";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        nixpkgs-unstable.follows = "nixpkgs-unstable";
        nixlib.follows = "nixpkgs";
        home-manager.follows = "home";
        flake-utils.follows = "flake-utils";
      };
    };
    lanzaboote = {
      url = "github:nix-community/lanzaboote";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };
    simple-nixos-mailserver = {
      url = "gitlab:simple-nixos-mailserver/nixos-mailserver/nixos-23.05";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
      inputs.utils.follows = "flake-utils";
    };
  };

  outputs = inputs@{ self, ... }:
    let
      inherit (builtins) listToAttrs concatLists attrValues attrNames readDir;
      inherit (inputs.nixpkgs) lib;
      inherit (lib) mapAttrs mapAttrsToList hasSuffix;
      sshKeys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIC2sdJFvvnEIYztPcznXvKpY4vOWedZ1qzDaAgRxrczS jp@war"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAII9ckbhT0em/dL75+RV+sdqwbprRC9Ff/MoqqpBgbUSh jp@pestilence"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIO8F6mLnoZq/Z1nnLiWPs0f6MlPN4AS7HmwmuheDebxS jp@famine"
      ];
      colors = {
        dark = {
          "base00" = "#002b36"; # background
          "base01" = "#073642"; # lighter background
          "base02" = "#586e75"; # selection background
          "base03" = "#657b83"; # comments, invisibles, line highlighting
          "base04" = "#839496"; # dark foreground
          "base05" = "#93a1a1"; # default foreground
          "base06" = "#eee8d5"; # light foreground
          "base07" = "#fdf6e3"; # light background
          "base08" = "#dc322f"; # red       variables
          "base09" = "#cb4b16"; # orange    integers, booleans, constants
          "base0A" = "#b58900"; # yellow    classes
          "base0B" = "#859900"; # green     strings
          "base0C" = "#2aa198"; # aqua      support, regular expressions
          "base0D" = "#268bd2"; # blue      functions, methods
          "base0E" = "#6c71c4"; # purple    keywords, storage, selector
          "base0F" =
            "#d33682"; # deprecated, opening/closing embedded language tags
        };
        light = {
          "base00" = "#fdf6e3";
          "base01" = "#eee8d5";
          "base02" = "#93a1a1";
          "base03" = "#839496";
          "base04" = "#657b83";
          "base05" = "#586e75";
          "base06" = "#073642";
          "base07" = "#002b36";
          "base08" = "#dc322f";
          "base09" = "#cb4b16";
          "base0A" = "#b58900";
          "base0B" = "#859900";
          "base0C" = "#2aa198";
          "base0D" = "#268bd2";
          "base0E" = "#6c71c4";
          "base0F" = "#d33682";
        };
      };
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
                    hostName = name;
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

    in { nixosConfigurations = mkHosts ./hosts; };
}
