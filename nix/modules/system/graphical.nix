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
  compiledLayout = pkgs.runCommand "keyboard-layout" {} ''
    ${pkgs.xorg.xkbcomp}/bin/xkbcomp ${configDir}/xkbmap $out
  '';
in
{
  options.modules.graphical = {
    enable = mkEnableOption "graphical";
  };

  config = mkIf cfg.enable {
    services.xserver = {
      enable = true;
      # TODO: laptop only
      libinput = {
        enable = true;
        touchpad.naturalScrolling = true;
      };
      displayManager = {
        setupCommands = ''
        ${pkgs.xorg.xkbcomp}/bin/xkbcomp ${compiledLayout} $DISPLAY
        ${pkgs.xcape}/bin/xcape -e 'Control_L=Escape'
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
          greeters.mini = {
            enable = true;
            inherit user;
            extraConfig = with colors.dark; ''
            font = Mono
            font-size = 1em
            font-weight = bold
            font-style = normal
            text-color = "#${base00}"
            error-color = "#${base08}"
            window-color = "#${base00}"
            border-color = "#${base04}"
            border-width = 2px
            layout-space = 15
            password-color = "#${base04}"
            password-background-color = "#${base00}"
            password-border-color = "#${base04}"
            password-border-width = 2px
            '';
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
      zathura
    ];

    # TODO: laptop only
    programs.light.enable = true;

    programs.nm-applet.enable = true;
  };
}
