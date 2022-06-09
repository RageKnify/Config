# flake.nix
#
# Author: João Borges <RageKnify@gmail.com>
# URL:    https://github.com/RageKnify/Config
#
# My config, based on RiscadoA's

{
  description = "Nix configuration for PCs and servers.";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-22.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-latest.url =  "github:nixos/nixpkgs/master";
    impermanence.url = "github:nix-community/impermanence/master";
    home = {
      url = "github:nix-community/home-manager/release-22.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ { self, ... }:
    let
      inherit (builtins) listToAttrs concatLists attrValues attrNames readDir;
      inherit (inputs.nixpkgs) lib;
      inherit (lib) mapAttrs removeSuffix hasSuffix;
      sshKeys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIC2sdJFvvnEIYztPcznXvKpY4vOWedZ1qzDaAgRxrczS jp@war"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHRO0/CTcEQHFV8C2REiurmTrPkd7nAlcwynI6eFCqu1 jp@death"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAII9ckbhT0em/dL75+RV+sdqwbprRC9Ff/MoqqpBgbUSh jp@pestilence"
      ];
      colors = {
        dark = {
          "base00" = "002b36";
          "base01" = "073642";
          "base02" = "586e75";
          "base03" = "657b83";
          "base04" = "839496";
          "base05" = "93a1a1";
          "base06" = "eee8d5";
          "base07" = "fdf6e3";
          "base08" = "dc322f";
          "base09" = "cb4b16";
          "base0A" = "b58900";
          "base0B" = "859900";
          "base0C" = "2aa198";
          "base0D" = "268bd2";
          "base0E" = "6c71c4";
          "base0F" = "d33682";
        };
        light = {
          "base00" = "fdf6e3";
          "base01" = "eee8d5";
          "base02" = "93a1a1";
          "base03" = "839496";
          "base04" = "657b83";
          "base05" = "586e75";
          "base06" = "073642";
          "base07" = "002b36";
          "base08" = "dc322f";
          "base09" = "cb4b16";
          "base0A" = "b58900";
          "base0B" = "859900";
          "base0C" = "2aa198";
          "base0D" = "268bd2";
          "base0E" = "6c71c4";
          "base0F" = "d33682";
        };
      };

      system = "x86_64-linux";
      user = "jp";

      mkPkgs = pkgs: extraOverlays: import pkgs {
        inherit system;
        config.allowUnfree = true;
        overlays = extraOverlays ++ (attrValues self.overlays);
      };

      pkgs = mkPkgs inputs.nixpkgs [ self.overlay ];
      pkgs' = mkPkgs inputs.nixpkgs-unstable [];
      pkgs'' = mkPkgs inputs.nixpkgs-latest [];

      mkOverlays = dir: listToAttrs (map
        (name: {
          name = removeSuffix ".nix" name;
          value = import "${dir}/${name}" {
            packageDir = ./packages;
          };
        })
        (attrNames (readDir dir)));

      systemModules = mkModules ./modules/system;
      homeModules = mkModules ./modules/home;

      # Imports every nix module from a directory, recursively.
      mkModules = dir: concatLists (attrValues (mapAttrs
        (name: value:
          if value == "directory"
          then mkModules "${dir}/${name}"
          else if value == "regular" && hasSuffix ".nix" name
          then [ (import "${dir}/${name}") ]
          else [])
        (readDir dir)));

      # Imports every host defined in a directory.
      mkHosts = dir: listToAttrs (map
        (name: {
          inherit name;
          value = inputs.nixpkgs.lib.nixosSystem {
            inherit system pkgs;
            specialArgs = { inherit user colors sshKeys; configDir = ./config; };
            modules = [
              { networking.hostName = name; }
              (dir + "/system.nix")
              (dir + "/${name}/hardware.nix")
              (dir + "/${name}/system.nix")
              inputs.home.nixosModules.home-manager {
                home-manager = {
                  useGlobalPkgs = true;
                  useUserPackages = true;
                  extraSpecialArgs = { inherit colors; configDir = ./config; };
                  sharedModules = homeModules;
                  users.${user} = import (dir + "/${name}/home.nix");
                };
              }
              inputs.impermanence.nixosModules.impermanence
            ] ++ systemModules;
          };
       })
       (attrNames (readDir dir)));

    in {
      overlay = final: prev: {
        unstable = pkgs';
        latest = pkgs'';
      };

      overlays = mkOverlays ./overlays;

      nixosConfigurations = mkHosts ./hosts;
    };
}
