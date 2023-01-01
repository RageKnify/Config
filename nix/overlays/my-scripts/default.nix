# overlays/my-scripts/default.nix
#
# Author: João Borges <RageKnify@gmail.com>
# URL:    https://github.com/RageKnify/Config
#
# Include some useful scripts

{ ... }: final: prev: rec {
  dnd_book = import ./dnd_book.nix { inherit final prev; };
  power_menu = import ./power_menu.nix { inherit final prev; };
  horseman_wallpaper = import ./horseman_wallpaper.nix { inherit final prev; };
}
