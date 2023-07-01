# profiles/common.nix
#
# Author: João Borges <RageKnify@gmail.com>
# URL:    https://github.com/RageKnify/Config
#
# System config common across all hosts

{ inputs, pkgs, lib, ... }:
let
  inherit (builtins) toString;
  inherit (lib.my) mapModules;
in {
  nix = {
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
    package = pkgs.nixFlakes;
    registry.nixpkgs.flake = inputs.nixpkgs;
    settings.trusted-users = [ "root" "@wheel" ];
  };
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
      hashedPassword =
        "$6$ISAN7cArW1aVhCSd$p3a.cLXkyl13EUKC2tSjhFRW0Wy2gTyzmdkvVVvtU1QaS14BAzS7acXOZ6xb2Baog8ur6q88FY639bKci.1Gh/";
      createHome = true;
      shell = pkgs.fish;
      extraGroups = [ "wheel" ];
    };
  };

  # make fish a login shell so that lightdm doesn't discriminate
  environment.shells = [ pkgs.fish ];
  # necessary for completions to work
  programs.fish.enable = true;

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
    fd
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
  security.pki.certificateFiles = [
    (builtins.fetchurl {
      url = "https://rnl.tecnico.ulisboa.pt/ca/cacert/cacert.pem";
      sha256 = "020vnbvjly6kl0m6sj4aav05693prai10ny7hzr7n58xnbndw3j2";
    })
  ];

  environment.etc."ssl/certs/tecnico-ca.pem".source = (builtins.fetchurl {
    url = "https://si.tecnico.ulisboa.pt/configuracoes/cacert.crt";
    sha256 = "1yj2liyccwg6srxjzxfbk67wmkqdwxcx78khfi64ds8rgvs3n6hp";
  });

  boot.tmp.cleanOnBoot = true;

  system.stateVersion = lib.mkDefault "21.11";
}