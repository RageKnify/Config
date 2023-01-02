# modules/system/graphical.nix
#
# Author: João Borges <RageKnify@gmail.com>
# URL:    https://github.com/RageKnify/Config
#
# Login manager and graphical configuration.
{ pkgs, config, lib, user, colors, configDir, ... }:
let
  inherit (lib) mkEnableOption mkOption types mkIf;
  cfg = config.modules.graphical;
in
{
  options.modules.graphical = {
    enable = mkEnableOption "graphical";
    extraSetupCommands = mkOption { type = types.str; default = ""; };
  };

  config = mkIf cfg.enable {
    services.xserver = {
      enable = true;
      # TODO: laptop only
      libinput = {
        enable = true;
        touchpad.naturalScrolling = true;
      };
      layout = "pt";
      displayManager = {
        setupCommands = ''
        ${cfg.extraSetupCommands}
        '';
        defaultSession = "user-xsession";
        session = [
          {
            name = "user-xsession";
            manage = "desktop";
            start = ''
            exec $HOME/.xsession
            '';
          }
        ];
        lightdm = {
          enable = true;
          extraConfig = ''
            set logind-check-graphical=true
          '';
          greeters.gtk = {
            enable = true;
            theme = {
              package = pkgs.solarc-gtk-theme;
              name = "SolArc";
            };
            iconTheme = {
              package = pkgs.papirus-icon-theme;
              name = "Papirus-Dark";
            };
          };
        };
      };
    };

    services.redshift = {
      enable = true;
      temperature = {
        day = 4000;
        night = 2500;
      };
    };

    # Required for gtk. (copied from RiscadoA)
    services.dbus.packages = [ pkgs.dconf ];

    fonts.fonts = with pkgs; [
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji
      font-awesome
      (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
    ];

    sound.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
    };
    # rtkit is optional but recommended
    security.rtkit.enable = true;

    environment.systemPackages = with pkgs; [
      xorg.xkbcomp
      xscreensaver
      xclip
      xcape

      pavucontrol

      feh
      firefox
      libreoffice
      zathura
    ];

    services.gnome.gnome-keyring.enable = true;

    # TODO: laptop only
    programs.light.enable = true;

    programs.nm-applet.enable = true;
  };
}
