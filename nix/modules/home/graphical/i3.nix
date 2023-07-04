# modules/home/graphical/i3.nix
#
# Author: João Borges <RageKnify@gmail.com>
# URL:    https://github.com/RageKnify/Config
#
# i3 configuration.

{ pkgs, config, lib, hostName, colors, ... }:
let
  inherit (lib) mkEnableOption mkIf mkForce;
  cfg = config.modules.graphical.i3;
  i3Mod = "Mod4";
in {
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
          window = { hideEdgeBorders = "both"; };

          gaps = {
            inner = 0;
            outer = 0;
            smartGaps = true;
          };

          assigns = { "1" = [{ class = "firefox"; }]; };

          bars = [ ];

          startup = [
            {
              command = "nm-applet";
              notification = false;
            }
            {
              command =
                "${pkgs.systemd}/bin/systemctl --user start graphical-session-i3.target";
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
    xdg.dataFile."rofi/themes/power.rasi".text = with colors.dark; ''
      /**
       *
       * Author : Aditya Shakya (adi1090x)
       * Github : @adi1090x
       *
       * Rofi Theme File
       * Rofi Version: 1.7.3
       **/

      /*****----- Configuration -----*****/
      configuration {
          show-icons:                 false;
      }

      /*****----- Global Properties -----*****/
      * {
          background:     ${base00}ff;
          background-alt: ${base01}ff;
          foreground:     ${base05}ff;
          selected:       ${base02}ff;
          active:         ${base09}ff;
          urgent:         ${base0A}ff;
      }

      /*
      USE_BUTTONS=YES
      */

      /*****----- Main Window -----*****/
      window {
          transparency:                "real";
          location:                    center;
          anchor:                      center;
          fullscreen:                  false;
          width:                       800px;
          x-offset:                    0px;
          y-offset:                    0px;

          padding:                     0px;
          border:                      0px solid;
          border-radius:               10px;
          border-color:                @selected;
          cursor:                      "default";
          background-color:            @background;
      }

      /*****----- Main Box -----*****/
      mainbox {
          background-color:            transparent;
          orientation:                 horizontal;
          children:                    [ "imagebox", "listview" ];
      }

      /*****----- Imagebox -----*****/
      imagebox {
          spacing:                     0px;
          padding:                     30px;
          background-color:            transparent;
          background-image:            url("~/documents/pictures/Wallpapers/solarized_mountains.png", width);
          children:                    [ "inputbar", "dummy", "message" ];
      }

      /*****----- User -----*****/
      userimage {
          margin:                      0px 0px;
          border:                      10px;
          border-radius:               10px;
          border-color:                @background-alt;
          background-color:            transparent;
          background-image:            url("~/documents/pictures/Wallpapers/solarized_mountains.png", height);
      }

      /*****----- Inputbar -----*****/
      inputbar {
          padding:                     15px;
          border-radius:               10px;
          background-color:            @urgent;
          text-color:                  @background;
          children:                    [ "dummy", "prompt", "dummy"];
      }

      dummy {
          background-color:            transparent;
      }

      prompt {
          background-color:            inherit;
          text-color:                  inherit;
      }

      /*****----- Message -----*****/
      message {
          enabled:                     true;
          margin:                      0px;
          padding:                     15px;
          border-radius:               10px;
          background-color:            @active;
          text-color:                  @background;
      }
      textbox {
          background-color:            inherit;
          text-color:                  inherit;
          vertical-align:              0.5;
          horizontal-align:            0.5;
      }

      /*****----- Listview -----*****/
      listview {
          enabled:                     true;
          columns:                     2;
          lines:                       2;
          cycle:                       true;
          dynamic:                     true;
          scrollbar:                   false;
          layout:                      vertical;
          reverse:                     false;
          fixed-height:                true;
          fixed-columns:               true;

          spacing:                     30px;
          margin:                      30px;
          background-color:            transparent;
          cursor:                      "default";
      }

      /*****----- Elements -----*****/
      element {
          enabled:                     true;
          padding:                     18px 10px;
          border-radius:               20px;
          background-color:            @background-alt;
          text-color:                  @foreground;
          cursor:                      pointer;
      }
      element-text {
          font:                        "feather bold 32";
          background-color:            transparent;
          text-color:                  inherit;
          cursor:                      inherit;
          vertical-align:              0.5;
          horizontal-align:            0.5;
      }
      element selected.normal {
          background-color:            var(selected);
          text-color:                  var(background);
      }
    '';
    xdg.dataFile."rofi/themes/calc.rasi".text = with colors.dark; ''
      * {
          al: #00000000;
          bg: ${base00}ff;
          fg: ${base05}ff;
          se: ${base02}ff;
          ac: ${base09}ff;
      }
      window {
          background-color: @bg;
          border:           0px;
          border-color:     @ac;
          border-radius:    12px;
          location:         center;
          text-color:       @fg;
          width:            35%;
          x-offset:         0;
          y-offset:         0;
      }
      mainbox {
          background-color: @al;
          border: 0% 0% 0% 0%;
          border-color: @ac;
          border-radius: 0% 0% 0% 0%;
          padding: 0%;
          spacing: 0%;
      }
      textbox {
          padding: 0% 0% 0% 0.5%;
          text-color: @fg;
          background-color: @bg;
      }
      textbox-current-entry {
          padding: 0% 0% 0% 0.5%;
      }
      listview {
          border: 2px dash 0px 0px ;
          background-color: @al;
          cycle: false;
          dynamic: true;
          layout: vertical;
          padding: 0.5% 0.5% 0.5% 0.5%;
          spacing: 0%;
      }
      element {
          background-color: @al;
          border-radius: 0%;
          padding: 0%;
          text-color: @fg;
          children: [ element-text ];
      }
      element-text {
          background-color: inherit;
          text-color:       inherit;
      }
      element selected {
          background-color: @se;
      }
      scrollbar {
          width:        4px ;
          border:       0;
          handle-width: 8px ;
          padding:      0;
      }
      entry {
          padding: 0% 0% 0% 0.5%;
          spacing:    0;
          text-color: inherit;
          background-color: inherit;
      }
      prompt {
          padding: 0% 0% 0% 0.5%;
          text-color: inherit;
          background-color: inherit;
      }
      inputbar {
          spacing:    0;
          text-color: @bg;
          background-color: @ac;
          padding:    1px ;
          children:   [ prompt,textbox-prompt-colon,entry ];
      }
      textbox-prompt-colon {
          expand:     false;
          str:        ":";
          margin:     0px 0.3em 0em 0em ;
          text-color: inherit;
          background-color: inherit;
      }
    '';
    programs.rofi = {
      enable = true;
      plugins = with pkgs; [ pkgs.rofi-calc ];
      font = "JetBrainsMono Nerd Font Bold 14";
      extraConfig = {
        show-icons = true;
        icon-theme = "Papirus";
        display-drun = "";
        drun-display-format = "{name}";
        disable-history = false;
        sidebar-mode = false;
      };
      theme = let inherit (config.lib.formats.rasi) mkLiteral;
      in {
        # this is taken from adi1090x/rofi
        # 1080p/launchers/colorful/style_1.rasi
        "*" = with colors.dark; {
          al = mkLiteral "#00000000";
          bg = mkLiteral "${base00}ff";
          fg = mkLiteral "${base05}ff";
          se = mkLiteral "${base02}ff";
          ac = mkLiteral "${base09}ff";
        };
        window = {
          transparency = "real";
          background-color = mkLiteral "@bg";
          text-color = mkLiteral "@fg";
          border = mkLiteral "0px";
          border-color = mkLiteral "@ac";
          border-radius = mkLiteral "12px";
          width = mkLiteral "50%";
          location = mkLiteral "center";
          x-offset = 0;
          y-offset = 0;
        };
        prompt = {
          enabled = true;
          padding = mkLiteral "0.30% 1% 0% -0.5%";
          background-color = mkLiteral "@al";
          text-color = mkLiteral "@bg";
          font = "JetBrainsMono Nerd Font Bold 12";
        };
        entry = {
          background-color = mkLiteral "@al";
          text-color = mkLiteral "@bg";
          placeholder-color = mkLiteral "@bg";
          expand = true;
          horizontal-align = 0;
          placeholder = "Search";
          padding = mkLiteral "0.10% 0% 0% 0%";
          blink = true;
        };
        inputbar = {
          children = map mkLiteral [ "prompt" "entry" ];
          background-color = mkLiteral "@ac";
          text-color = mkLiteral "@bg";
          expand = false;
          border = mkLiteral "0% 0% 0% 0%";
          border-radius = mkLiteral "0px";
          border-color = mkLiteral "@ac";
          margin = mkLiteral "0% 0% 0% 0%";
          padding = mkLiteral "1.5%";
        };
        listview = {
          background-color = mkLiteral "@al";
          padding = mkLiteral "10px";
          columns = 4;
          lines = 4;
          spacing = mkLiteral "0%";
          cycle = false;
          dynamic = true;
          layout = mkLiteral "vertical";
        };
        mainbox = {
          background-color = mkLiteral "@al";
          border = mkLiteral "0% 0% 0% 0%";
          border-radius = mkLiteral "0% 0% 0% 0%";
          border-color = mkLiteral "@ac";
          children = map mkLiteral [ "inputbar" "listview" ];
          spacing = mkLiteral "0%";
          padding = mkLiteral "0%";
        };
        element = {
          background-color = mkLiteral "@al";
          text-color = mkLiteral "@fg";
          orientation = mkLiteral "vertical";
          border-radius = mkLiteral "0%";
          padding = mkLiteral "2% 0% 2% 0%";
        };
        element-icon = {
          background-color = mkLiteral "inherit";
          text-color = mkLiteral "inherit";
          horizontal-align = mkLiteral "0.5";
          vertical-align = mkLiteral "0.5";
          size = mkLiteral "64px";
          border = mkLiteral "0px";
        };
        element-text = {
          background-color = mkLiteral "@al";
          text-color = mkLiteral "inherit";
          expand = mkLiteral "true";
          horizontal-align = mkLiteral "0.5";
          vertical-align = mkLiteral "0.5";
          margin = mkLiteral "0.5% 0.5% -0.5% 0.5%";
        };
        "element selected" = {
          background-color = mkLiteral "@se";
          text-color = mkLiteral "@fg";
          border = mkLiteral "0% 0% 0% 0%";
          border-radius = mkLiteral "12px";
          border-color = mkLiteral "@bg";
        };
      };
    };
    services.picom = {
      enable = true;
      vSync = true;
    };
    services.dunst = {
      enable = true;
      settings = {
        global = {
          follow = "mouse";
          width = "(200, 300)";
          height = 200;
          notification_limit = 2;
          offset = "(30, 30)";
          padding = 6;
          font = "Monospace 14";
          horizontal_padding = 6;
          dmenu = "${pkgs.rofi}/bin/rofi -dmenu";
          frame_color = "${colors.dark.base00}";
        };
        urgency_low = with colors.dark; {
          background = "${base01}";
          foreground = "${base05}";
        };
        urgency_normal = with colors.dark; {
          background = "${base01}";
          foreground = "${base05}";
        };
        urgency_critical = with colors.dark; {
          background = "${base01}";
          foreground = "${base08}";
          frame_color = "${base08}";
        };
      };
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
      imageDirectory = "%h/documents/pictures/Wallpapers/${hostName}";
      interval = "10m";
    };
  };
}
