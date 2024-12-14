# profiles/graphical/full.nix
#
# Author: João Borges <RageKnify@gmail.com>
# URL:    https://github.com/RageKnify/Config
#
# Login manager and graphical configuration.

{ pkgs, config, lib, profiles, ... }:
let hostName = config.networking.hostName;
in {
  imports = with profiles.nixos.graphical; [ firefox ];

  services.xserver = {
    enable = true;
    xkb = {
      layout = "us,us";
      variant = ",intl";
    };
    displayManager = {
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
          extraConfig = ''
            background=${./wallpapers}/${hostName}/1.png
          '';
        };
      };
    };
  };
  services.displayManager.defaultSession = "user-xsession";

  services.redshift = {
    enable = true;
    temperature = {
      day = 4000;
      night = 2500;
    };
  };

  location = {
    provider = "manual";
    # Lisboa, Portugal
    latitude = 38.43;
    longitude = -9.8;
  };

  # Required for gtk. (copied from RiscadoA)
  services.dbus.packages = [ pkgs.dconf ];
  programs.dconf.enable = true;

  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-emoji
    font-awesome
    (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
  ];

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
    dolphin
    feh
    gimp
    libreoffice
    pavucontrol
    thunderbird
    unstable.ghidra-bin
    latest.signal-desktop
    vlc
    xcape
    xclip
    xorg.xkbcomp
    zathura
  ];

  services.gnome.gnome-keyring.enable = true;
}
