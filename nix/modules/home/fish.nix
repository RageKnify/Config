# modules/home/fish.nix
#
# Author: João Borges <RageKnify@gmail.com>
# URL:    https://github.com/RageKnify/Config
#
# Fish home configuration.

{ pkgs, ... }:
{
  programs.fish.enable = true;
  programs.fish.shellAbbrs = {
    n = "nvim";
    nv = "nvim";
  };

  # starship
  programs.starship.package = pkgs.unstable.starship;
  programs.starship.enable = true;
  programs.fish.interactiveShellInit = ''
  starship init fish | source
  fish_vi_key_bindings
  '';
  programs.starship.settings = {
    scan_timeout = 1;
    add_newline = false;

    username.format = "[$user]($style)[@](bold green)";
    hostname = {
      ssh_only = false;
      format = "[$hostname]($style) ";
      style = "bold blue";
    };
    directory = {
      style = "bold purple";
      truncation_length = 2;
    };
    git_branch =  {
      format = "[$branch]($style) ";
      style = "bold green";
    };
    git_commit.format =  "[$tag]($style)";
    git_state.format = "[$state( $progress_current/$progress_total)]($style)";
    git_status = {
      style = "yellow";
      format = "([\[$all_status$ahead_behind\]]($style) )";
    };
    package.disabled = true;
    perl.disabled = true;
    line_break.disabled = true;
    status = {
      format = "[$status ]($style)";
      disabled = false;
    };
    sudo.disabled = false;
    character.format = "[⋉ ](white)";
  };
}
