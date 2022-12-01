# hosts/system.nix
#
# Author: João Borges <RageKnify@gmail.com>
# URL:    https://github.com/RageKnify/Config
#
# System config common across all hosts

{ inputs, pkgs, lib, configDir, ... }:
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
  nix.settings.trusted-users = [ "root" "@wheel" ];
  security.sudo.extraConfig = ''
  Defaults pwfeedback
  Defaults lecture=never
  '';

  # Every host shares the same time zone.
  time.timeZone = "Europe/Lisbon";

  services.journald.extraConfig = ''
  SystemMaxUse=500M
  '';

  users = {
    users.jp = {
      isNormalUser = true;
      hashedPassword = "$6$ISAN7cArW1aVhCSd$p3a.cLXkyl13EUKC2tSjhFRW0Wy2gTyzmdkvVVvtU1QaS14BAzS7acXOZ6xb2Baog8ur6q88FY639bKci.1Gh/";
      createHome = true;
      shell = pkgs.fish;
      extraGroups = [ "wheel" ];
    };
  };

  # make fish a login shell so that lightdm doesn't discriminate
  environment.shells = [ pkgs.fish ];

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
    # backups
    restic
    rclone
  ];

  # dedup equal pages
  hardware.ksm = {
    enable = true;
    sleep = null;
  };

  networking.search = [ "rnl.tecnico.ulisboa.pt" ];
  security.pki.certificateFiles = [ "${configDir}/certs/rnl.crt" ];

  system.stateVersion = "21.11";
}
