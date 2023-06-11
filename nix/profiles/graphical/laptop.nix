# profiles/graphical/laptop.nix
#
# Author: João Borges <RageKnify@gmail.com>
# URL:    https://github.com/RageKnify/Config
#
# graphical options for laptops

{ pkgs, config, lib, user, colors, ... }: {
  services.xserver.libinput = {
    enable = true;
    touchpad.naturalScrolling = true;
  };

  programs.light.enable = true;

  programs.nm-applet.enable = true;
}
