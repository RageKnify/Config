# hosts/system.nix
#
# System config common across all hosts

{ inputs, pkgs, lib, ... }:
let
  inherit (builtins) toString;
  inherit (lib.my) mapModules;
in
{
  nix = {
    package = pkgs.nixFlakes;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };
  nix.trustedUsers = [ "root" "@wheel" ];

  # Every host shares the same time zone.
  time.timeZone = "Europe/Lisbon";

  # Essential packages.
  environment.systemPackages = with pkgs; [
    cached-nix-shell
    neovim
    zip
    unzip
    htop
    neofetch
    man-pages
  ];

  system.stateVersion = "21.11";
}
