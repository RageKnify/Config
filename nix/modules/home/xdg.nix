# modules/home/xdg.nix
#
# Author: João Borges <RageKnify@gmail.com>
# URL:    https://github.com/RageKnify/Config
#
# XDG home configuration. (Based on RiscadoA's)

{ pkgs, lib, config, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  jp-downloads-script = pkgs.writeShellScript "jp-downloads-script.sh" ''
    ${pkgs.coreutils}/bin/mkdir /dev/shm/jp-downloads
    ${pkgs.coreutils}/bin/ln -s /dev/shm/jp-downloads -fT /home/jp/downloads
  '';
  cfg = config.modules.xdg;
in {
  options.modules.xdg.enable = mkEnableOption "xdg";

  config = mkIf cfg.enable {
    xdg = {
      enable = true;
      userDirs = {
        enable = true;
        desktop = "$HOME/documents/desktop/";
        documents = "$HOME/documents/";
        download = "$HOME/downloads/";
        music = "$HOME/documents/music/";
        pictures = "$HOME/documents/pictures/";
        publicShare = "$HOME/documents/public/";
        templates = "$HOME/documents/templates/";
        videos = "$HOME/documents/videos/";
      };
    };
    systemd.user.services = {
      home-jp-downloads = {
        Install = { WantedBy = [ "graphical-session.target" ]; };
        Unit = {
          PartOf = [ "graphical-session.target" ];
          Description = "Link /home/jp/downloads to a directory in tmpfs";
        };
        Service = { ExecStart = "${jp-downloads-script}"; };
      };
    };
  };
}
