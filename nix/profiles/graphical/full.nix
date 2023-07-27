# profiles/graphical/full.nix
#
# Author: João Borges <RageKnify@gmail.com>
# URL:    https://github.com/RageKnify/Config
#
# Login manager and graphical configuration.

{ pkgs, config, lib, user, ... }: {
  services.xserver = {
    enable = true;
    layout = "pt";
    displayManager = {
      defaultSession = "user-xsession";
      session = [{
        name = "user-xsession";
        manage = "desktop";
        start = ''
          exec $HOME/.xsession
        '';
      }];
      lightdm = {
        enable = true;
        extraConfig = ''
          set logind-check-graphical=true
        '';
        greeters.slick = {
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
    arandr
    (discord.override {
      nss = nss_latest; # hyperlinks can't open in Firefox without this
      withOpenASAR = true; # it's supposed to be better
    })
    feh
    gimp
    libreoffice
    obsidian
    pavucontrol
    thunderbird
    unstable.ghidra-bin
    unstable.signal-desktop
    vlc
    xcape
    xclip
    xorg.xkbcomp
    zathura
  ];

  programs.firefox.enable = true;

  services.gnome.gnome-keyring.enable = true;
}
