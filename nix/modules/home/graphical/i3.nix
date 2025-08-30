# modules/home/graphical/i3.nix
#
# Author: João Borges <RageKnify@gmail.com>
# URL:    https://github.com/RageKnify/Config
#
# i3 configuration.

{
  pkgs,
  lib,
  config,
  osConfig,
  myLib,
  ...
}:
let
  inherit (lib)
    lists
    mkEnableOption
    mkIf
    mkForce
    ;
  cfg = config.modules.graphical.i3;
  laptop = osConfig.modules.laptop;
  hostName = osConfig.networking.hostName;
  colors = myLib.colors;
  i3Mod = "Mod4";
in
{
  options.modules.graphical.i3.enable = mkEnableOption "i3";

  config = mkIf cfg.enable {
    home.pointerCursor = {
      package = pkgs.quintom-cursor-theme;
      name = "Quintom_Ink";
      size = 28;
      x11.enable = true;
    };
    xsession = {
      enable = true;
      windowManager.i3 = {
        enable = true;
        config = {
          modifier = i3Mod;

          focus.newWindow = "urgent";

          keybindings = lib.mkOptionDefault {
            # switch to next or previous workspace
            "${i3Mod}+Tab" = "workspace next";
            "${i3Mod}+Shift+Tab" = "workspace prev";

            # change gaps
            "${i3Mod}+s" = "gaps inner current plus 5";
            "${i3Mod}+Shift+s" = "gaps inner current minus 5";

            "${i3Mod}+Shift+r" = "restart";
            "${i3Mod}+r" = ''mode "resize"'';

            "${i3Mod}+g" = "split h";

            # change focus
            "${i3Mod}+h" = "focus left";
            "${i3Mod}+j" = "focus down";
            "${i3Mod}+k" = "focus up";
            "${i3Mod}+l" = "focus right";
            # alternatively, you can use the cursor keys:
            "${i3Mod}+Left" = "focus left";
            "${i3Mod}+Down" = "focus down";
            "${i3Mod}+Up" = "focus up";
            "${i3Mod}+Right" = "focus right";

            # move focused window
            "${i3Mod}+Shift+h" = "move left";
            "${i3Mod}+Shift+j" = "move down";
            "${i3Mod}+Shift+k" = "move up";
            "${i3Mod}+Shift+l" = "move right";
            # alternatively, you can use the cursor keys:
            "${i3Mod}+Shift+Left" = "move left";
            "${i3Mod}+Shift+Down" = "move down";
            "${i3Mod}+Shift+Up" = "move up";
            "${i3Mod}+Shift+Right" = "move right";

            # move workspace to next output
            "${i3Mod}+n" = "move workspace to output next";
          };

          modes = {
            resize = {
              Escape = "mode default";

              h = "resize shrink width 5 px or 5 ppt";
              j = "resize grow height 5 px or 5 ppt";
              k = "resize shrink height 5 px or 5 ppt";
              l = "resize grow width 5 px or 5 ppt";

              Left = "resize shrink width 5 px or 5 ppt";
              Down = "resize grow height 5 px or 5 ppt";
              Up = "resize shrink height 5 px or 5 ppt";
              Right = "resize grow width 5 px or 5 ppt";
            };
          };

          colors = with colors.dark; {
            focused = {
              border = "${base05}";
              background = "${base00}";
              text = "${base05}";
              indicator = "${base05}";
              childBorder = "${base05}";
            };
            focusedInactive = {
              border = "${base01}";
              background = "${base01}";
              text = "${base05}";
              indicator = "${base03}";
              childBorder = "${base01}";
            };
            unfocused = {
              border = "${base01}";
              background = "${base00}";
              text = "${base05}";
              indicator = "${base01}";
              childBorder = "${base01}";
            };
            urgent = {
              border = "${base08}";
              background = "${base08}";
              text = "${base00}";
              indicator = "${base08}";
              childBorder = "${base08}";
            };
            placeholder = {
              border = "${base00}";
              background = "${base00}";
              text = "${base05}";
              indicator = "${base00}";
              childBorder = "${base00}";
            };
            background = "${base07}";
          };

          fonts = {
            names = [ "JetBrains Mono Nerd Font" ];
            style = "Bold Semi-Condensed";
            size = 14.0;
          };

          menu = "${pkgs.rofi}/bin/rofi -matching normal -modi drun -show drun";
          window = {
            hideEdgeBorders = "both";
          };

          gaps = {
            inner = 0;
            outer = 0;
            smartGaps = true;
          };

          assigns = {
            "1" = [ { class = "(?i)firefox"; } ];
            "10" = [ { class = "discord"; } ];
          };

          bars = [ ];

          startup =
            [
              {
                command = "${pkgs.systemd}/bin/systemctl --user start graphical-session-i3.target";
                notification = false;
              }
            ]
            ++ lists.optionals laptop.enable [
              {
                command = "nm-applet";
                notification = false;
              }
            ];
          workspaceAutoBackAndForth = true;
        };
      };
    };
    systemd.user.targets.graphical-session-i3 = {
      Unit = {
        Description = "i3 X session";
        BindsTo = [ "graphical-session.target" ];
        Requisite = [ "graphical-session.target" ];
      };
    };
    systemd.user.services.polybar = {
      Unit.PartOf = mkForce [ "graphical-session-i3.target" ];
      Install.WantedBy = mkForce [ "graphical-session-i3.target" ];
    };
    services.picom = {
      enable = false;
      vSync = true;
    };
    services.xscreensaver = {
      enable = true;
      settings = {
        # TODO: this shit doesn't fucking work
        # lock = true;
        # mode = "blank";
        # dialogTheme = "darkgray";
        # lockTimeout = 1;
      };
    };
    services.random-background = {
      enable = true;
      enableXinerama = true;
      display = "fill";
      imageDirectory = "${./../../../profiles/nixos/graphical/wallpapers}/${hostName}";
      interval = "10m";
    };
  };
}
