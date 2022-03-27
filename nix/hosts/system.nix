# hosts/system.nix
#
# Author: João Borges <RageKnify@gmail.com>
# URL:    https://github.com/RageKnify/Config
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
  security.sudo.extraConfig = "Defaults pwfeedback";

  # Every host shares the same time zone.
  time.timeZone = "Europe/Lisbon";

  services.journald.extraConfig = ''
  SystemMaxUse=500M
  '';

  # Essential packages.
  environment.systemPackages = with pkgs; [
    cached-nix-shell
    neovim
    tmux
    zip
    unzip
    htop
    neofetch
    man-pages
    fzf
    ripgrep
    procps
  ];

  system.stateVersion = "21.11";
}
