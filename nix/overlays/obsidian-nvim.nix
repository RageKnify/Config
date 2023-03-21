# overlays/obsidian-nvim.nix
#
# Author: João Borges <RageKnify@gmail.com>
# URL:    https://github.com/RageKnify/Config
#
# Have access to obisdian.nvim

{ inputs, ... }: final: prev: rec {
  obsidian-nvim = final.vimUtils.buildVimPlugin {
    name = "obsidian-nvim";
    src = inputs.obsidian-nvim;
    dontBuild = true;
  };
}
