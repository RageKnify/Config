# modules/home/fish.nix
#
# Author: João Borges <RageKnify@gmail.com>
# URL:    https://github.com/RageKnify/Config
#
# Fish configuration.

{ pkgs, config, lib, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.modules.fish;
in
{
  options.modules.fish.enable = mkEnableOption "fish";

  config = mkIf cfg.enable {
    programs.fish = {
      enable = true;
      shellAbbrs = {
        cd = "z";
        n = mkIf config.modules.neovim.enable "nvim";
        nv = mkIf config.modules.neovim.enable "nvim";
      };
      functions = {
        greeting = ''
          echo
          echo -e (uname -ro | awk '{print " \\\\e[1mOS: \\\\e[0;32m"$0"\\\\e[0m"}')
          echo -e (uptime -p | cut -d , -f 1 | sed -E 's/.*up +//' | awk '{print " \\\\e[1mUptime: \\\\e[0;32m"$0"\\\\e[0m"}')
          echo -e (hostname | awk '{print " \\\\e[1mHostname: \\\\e[0;32m"$0"\\\\e[0m"}')
          echo -e " \\e[1mDisk usage:\\e[0m"
          # echo
          echo -ne (\
            df -l -h | grep -E 'dev/nvme0n1' | \
            awk '{printf "\\\\t%s\\\\t%4s / %4s  %s\\\\n\n", $6, $3, $2, $5}' | \
            sed -e 's/^\(.*\([8][5-9]\|[9][0-9]\)%.*\)$/\\\\e[0;31m\1\\\\e[0m/' -e 's/^\(.*\([7][5-9]\|[8][0-4]\)%.*\)$/\\\\e[0;33m\1\\\\e[0m/' | \
            paste -sd ''\'''\'\
          )
          echo

          echo -e " \\e[1mNetwork:\\e[0m"
          # echo
          # http://tdt.rocks/linux_network_interface_naming.html
          echo -ne (\
            ip addr show up scope global | \
              grep -E ': <|inet' | \
              sed \
                -e 's/^[[:digit:]]\+: //' \
                -e 's/: <.*//' \
                -e 's/.*inet[[:digit:]]* //' \
                -e 's/\/.*//'| \
              awk 'BEGIN {i=""} /\.|:/ {print i" "$0"\\\n"; next} // {i = $0}' | \
              sort | \
              column -t -R1 | \
              # # public addresses are underlined for visibility \
              # sed 's/ \([^ ]\+\)$/ \\\e[4m\1/' | \
              # private addresses are not \
              sed 's/m\(\(10\.\|172\.\(1[6-9]\|2[0-9]\|3[01]\)\|192\.168\.\).*\)/m\\\e[24m\1/' | \
              # unknown interfaces are cyan \
              sed 's/^\( *[^ ]\+\)/\\\e[36m\1/' | \
              # ethernet interfaces are normal \
              sed 's/\(\(en\|em\|eth\)[^ ]* .*\)/\\\e[39m\1/' | \
              # wireless interfaces are purple \
              sed 's/\(wl[^ ]* .*\)/\\\e[35m\1/' | \
              # wwan interfaces are yellow \
              sed 's/\(ww[^ ]* .*\).*/\\\e[33m\1/' | \
              sed 's/$/\\\e[0m/' | \
              sed 's/^/\t/' \
            )
          if [ -f ./TODO.txt ]
            set TODO (cat ./TODO.txt)
          else if [ -f ~/TODO.txt ]
            set TODO (cat ~/TODO.txt)
          end
          if [ "$TODO" != "" ]
            set_color normal
            echo -e "\n \\e[1mTODO:\\e[0m"
            for LINE in $TODO
              set_color green
              echo -e "\t$LINE"
            end
          end
        '';
        fish_greeting = ''
          set fishes (pidof fish | wc -w)
          if test $fishes -eq "1"
            greeting
          end
        '';
      };
    };

    # starship
    programs.starship.package = pkgs.unstable.starship;
    programs.starship.enable = true;
    # zoxide
    programs.zoxide.enable = true;
    home.sessionVariables._ZO_ECHO = "1";

    programs.fish.interactiveShellInit = ''
    # starship init
    starship init fish | source

    fish_vi_key_bindings
    # fzf stuf
    source (fzf-share)/key-bindings.fish
    fzf_key_bindings
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
        format = "([\\[$all_status$ahead_behind\\]]($style) )";
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
  };
}
