# hosts/lazarus/system.nix
#
# Author: João Borges <RageKnify@gmail.com>
# URL:    https://github.com/RageKnify/Config
#
# XDG home configuration. (Based on RiscadoA's)

{ lib, config, ... }:
let
  inherit (lib) mkEnableOption mkIf;
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
        createDirectories = true;
      };
    };
    systemd.user.mounts = {
      home-jp-downloads = {
        Unit = {
          Description = "Mount /home/jp/downloads as a tmpfs";
          PartOf = [ "default.target" ];
        };
        Install = { WantedBy = [ "default.target" ]; };
        Mount = {
          where = "$HOME/downloads/";
          type = "tmpfs";
          mountConfig.Options = [ "mode=1755" "strictatime" "rw" "nosuid" "nodev" "size=50%" ];
        };
      };
    };
  };
}
