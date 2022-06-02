# modules/home/graphical/i3.nix
#
# Author: João Borges <RageKnify@gmail.com>
# URL:    https://github.com/RageKnify/Config
#
# i3 configuration.

{ pkgs, config, lib, colors, configDir, ... }:
let
  inherit (lib) mkEnableOption mkIf mkForce;
  cfg = config.modules.graphical.i3;
  i3Mod = "Mod4";
  i3Pkg = pkgs.i3-gaps;
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
        package = i3Pkg;
        config = {
          modifier = i3Mod;

          keybindings = lib.mkOptionDefault {
            # switch to next or previous workspace
            "${i3Mod}+Tab"       = "workspace next";
            "${i3Mod}+Shift+Tab" = "workspace prev";

            # change gaps
            "${i3Mod}+s"        = "gaps inner current plus 5";
            "${i3Mod}+Shift+s"  = "gaps inner current minus 5";

            "${i3Mod}+Shift+r"  = "restart";
            "${i3Mod}+r"        = "mode \"resize\"";

            "${i3Mod}+g"        = "split h";

            # change focus
            "${i3Mod}+h"      = "focus left";
            "${i3Mod}+j"      = "focus down";
            "${i3Mod}+k"      = "focus up";
            "${i3Mod}+l"      = "focus right";
            # alternatively, you can use the cursor keys:
            "${i3Mod}+Left"   = "focus left";
            "${i3Mod}+Down"   = "focus down";
            "${i3Mod}+Up"     = "focus up";
            "${i3Mod}+Right"  = "focus right";

            # move focused window
            "${i3Mod}+Shift+h"      = "move left";
            "${i3Mod}+Shift+j"      = "move down";
            "${i3Mod}+Shift+k"      = "move up";
            "${i3Mod}+Shift+l"      = "move right";
            # alternatively, you can use the cursor keys:
            "${i3Mod}+Shift+Left"   = "move left";
            "${i3Mod}+Shift+Down"   = "move down";
            "${i3Mod}+Shift+Up"     = "move up";
            "${i3Mod}+Shift+Right"  = "move right";
          };

          modes = {
            resize = {
              Escape = "mode default";

              h = "resize shrink width 5 px or 5 ppt";
              j = "resize grow height 5 px or 5 ppt";
              k = "resize shrink height 5 px or 5 ppt";
              l = "resize grow width 5 px or 5 ppt";

              Left  = "resize shrink width 5 px or 5 ppt";
              Down  = "resize grow height 5 px or 5 ppt";
              Up    = "resize shrink height 5 px or 5 ppt";
              Right = "resize grow width 5 px or 5 ppt";
            };
          };

          colors  = with colors.dark; {
            focused = {
              border = "#${base05}";
              background = "#${base00}";
              text = "#${base05}";
              indicator = "#${base05}";
              childBorder = "#${base05}";
            };
            focusedInactive = {
              border = "#${base01}";
              background = "#${base01}";
              text = "#${base05}";
              indicator = "#${base03}";
              childBorder = "#${base01}";
            };
            unfocused = {
              border = "#${base01}";
              background = "#${base00}";
              text = "#${base05}";
              indicator = "#${base01}";
              childBorder = "#${base01}";
            };
            urgent = {
              border = "#${base08}";
              background = "#${base08}";
              text = "#${base00}";
              indicator = "#${base08}";
              childBorder = "#${base08}";
            };
            placeholder = {
              border = "#${base00}";
              background = "#${base00}";
              text = "#${base05}";
              indicator = "#${base00}";
              childBorder = "#${base00}";
            };
            background = "#${base07}";
          };

          fonts = {
            names = [ "JetBrains Mono Nerd Font" ];
            style = "Bold Semi-Condensed";
            size = 14.0;
          };

          menu = "${pkgs.rofi}/bin/rofi -matching fuzzy -modi drun -show drun";
          window = {
            hideEdgeBorders = "both";
          };

          gaps = {
            inner = 0;
            outer = 0;
            smartGaps = true;
          };

          assigns = {
            "1" = [{ class = "Firefox"; }];
            "5" = [{ class = "Thunderbird"; }];
            "7" = [{ class = "Gimp"; }];
            "10" = [{ class = "discord"; }];
          };

          bars = [];

          startup = [
            { command = "nm-applet"; notification = false; }
            {
              command = "${pkgs.systemd}/bin/systemctl --user start graphical-session-i3.target";
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
    services.polybar = {
      enable = true;
      script = ''
      for m in $(${pkgs.xorg.xrandr}/bin/xrandr --query | ${pkgs.gnugrep}/bin/grep " connected" | ${pkgs.coreutils}/bin/cut -d" " -f1); do
        MONITOR=$m polybar --reload bar&
      done
      '';
      package = (pkgs.polybar.override { i3GapsSupport = true; pulseSupport = true; });
      settings = with colors.dark; {
        colors  = {
          background      = "#${base00}";
          background-alt  = "#${base01}";
          foreground      = "#${base05}";
          foreground-alt  = "#${base06}";
          primary         = "#${base09}";
          secondary       = "#${base0A}";
          alert           = "#${base08}";
        };
        "global/wm" = {
          margin-top = 5;
          margin-bottom = 5;
        };
        "bar/bar" = {
          width = "100%";
          height = 22;
          fixed-center = false;
          background = "\${colors.background}";
          foreground = "\${colors.foreground}";
          line-size = 3;
          line-color = "#f00";
          module-margin-left = 0;
          module-margin-right = 1;
          font = [
            "JetBrainsMono:pixelsize=14;4"
            "Font Awesome 6 Free:style=regular;4"
            "Font Awesome 6 Free:style=solid;4"
            "Font Awesome 6 Brands,Font Awesome 6 Brands Regular:style=Regular;4"
          ];
          tray-position = "right";
          tray-padding = 1;
          padding = 0;
          bottom = false;
          monitor = "\${env:MONITOR:eDP-1}";
          # modules-left = i3 xkeyboard mpd pulseaudio
          modules-left = "i3 xkeyboard pulseaudio";
          # modules-right = filesystem0 filesystem1 cpu temperature memory wlan battery date
          modules-right = "cpu temperature memory wlan battery date";
        };
        "module/i3" = {
          type = "internal/i3";
          format = "<label-state> <label-mode>";
          index-sort = true;
          wrapping-scroll = false;
          label-mode-padding = 2;
          label-mode-foreground = "#000";
          label-mode-background = "\${colors.primary}";

          # focused = Active workspace on focused monitor
          label-focused = "%icon%";
          label-focused-background = "\${colors.background-alt}";
          label-focused-overline = "\${colors.primary}";
          label-focused-padding = 2;

          # unfocused = Inactive workspace on any monitor
          label-unfocused = "%icon%";
          label-unfocused-padding = 2;

          # visible = Active workspace on unfocused monitor
          label-visible = "%icon%";
          label-visible-background = "\${self.label-focused-background}";
          label-visible-overline = "\${self.label-focused-overline}";
          label-visible-padding = "\${self.label-focused-padding}";

          # urgent = Workspace with urgency hint set
          label-urgent = "%icon%";
          label-urgent-background = "\${colors.alert}";
          label-urgent-padding = 2;

          ws-icon-0 = "1;";
          ws-icon-1 = "2;";
          ws-icon-2 = "3;";
          ws-icon-3 = "4;";
          ws-icon-4 = "5;";
          ws-icon-5 = "6;";
          ws-icon-6 = "7;";
          ws-icon-7 = "8;";
          ws-icon-8 = "9;";
          ws-icon-9 = "10;";
        };
        "module/xkeyboard" = {
          type = "internal/xkeyboard";
          format-prefix = "  ";
          format-prefix-foreground = "\${colors.foreground-alt}";
          format-prefix-overline = "\${colors.secondary}";

          label-layout = "%layout%";
          label-layout-overline = "\${colors.secondary}";

          label-indicator-on = "%name%";
          label-indicator-on-padding = 2;
          label-indicator-on-margin = 1;
          label-indicator-on-foreground = "\${colors.background}";
          label-indicator-on-background = "\${colors.secondary}";
          label-indicator-on-overline = "\${colors.secondary}";

          blacklist-0 = "num lock";
        };
        # TODO: filesystem module on zfs
        "module/cpu" = {
          type = "internal/cpu";
          interval = 2;
          format-prefix = " ";
          format-prefix-foreground = "\${colors.foreground-alt}";
          format-overline = "#${base0E}";
          label = "%percentage%%";
        };
        "module/temperature" = {
          type = "internal/temperature";
          thermal-zone = "4";
          warn-temperature = 60;

          format = "<ramp> <label>";
          format-overline = "#${base0E}";
          format-warn = "<ramp> <label-warn>";
          format-warn-overline = "\${self.format-overline}";

          label = "%temperature-c%";
          label-warn = "%temperature-c%";
          label-warn-foreground = "#${base08}";

          ramp-0 = "";
          ramp-1 = "";
          ramp-2 = "";
          ramp-3 = "";
          ramp-4 = "";
          ramp-foreground = "\${colors.foreground-alt}";
        };
        "module/memory" = {
          type = "internal/memory";
          interval = 2;
          format-prefix = " ";
          format-prefix-foreground = "\${colors.foreground-alt}";
          format-overline = "#${base0C}";
          label = "%gb_used%/%gb_total%";
        };
        "module/date" = {
          type = "internal/date";
          interval = 5;
          date = "%d %b";
          date-alt = "%a %Y-%m-%d";
          time = "%H:%M";
          time-alt = "%H:%M:%S";
          format-prefix = " ";
          format-prefix-foreground = "\${colors.foreground-alt}";
          format-overline = "#${base08}";
          label = "%date% %time%";
        };
        "module/pulseaudio" = {
          type = "internal/pulseaudio";
          sink = "alsa_output.pci-0000_00_1f.3.analog-stereo";
        };
        # TODO: laptop only
        "module/battery" = {
          type = "internal/battery";
          battery = "BAT0";
          adapter = "ACAD";
          full-at = 100;
          time-format = "%H:%M";

          format-charging = "<animation-charging> <label-charging>";
          label-charging = "%percentage%%";
          format-charging-overline = "#${base0A}";

          format-discharging = "<ramp-capacity> <label-discharging>";
          label-discharging = "%percentage%%";
          format-discharging-overline = "\${self.format-charging-overline}";

          ramp-capacity-foreground = "\${colors.foreground-alt}";
          ramp-capacity-0 = "";
          ramp-capacity-1 = "";
          ramp-capacity-2 = "";
          ramp-capacity-3 = "";
          ramp-capacity-4 = "";

          format-full = "<label-full>";
          label-full = " %percentage%%";
          format-full-overline = "\${self.format-charging-overline}";

          animation-charging-0 = "";
          animation-charging-1 = "";
          animation-charging-2 = "";
          animation-charging-3 = "";
          animation-charging-4 = "";
          animation-charging-foreground = "\${colors.foreground-alt}";
          animation-charging-framerate = 750;
        };
        # TODO: laptop only
        "module/wlan" = {
          type = "internal/network";
          interface = "wlp2s0";
          interval = 3.0;
          format-connected-prefix = " ";
          format-disconnected-prefix = "\${self.format-connected-prefix}";
          format-connected-prefix-foreground = "\${colors.foreground-alt}";
          format-disconnected-prefix-foreground = "\${colors.foreground-alt}";

          format-connected = "<ramp-signal> <label-connected>";
          format-connected-overline = "#${base0B}";
          label-connected = "%essid%";

          format-disconnected = "<label-disconnected>";
          format-disconnected-overline = "\${self.format-connected-overline}";
          label-disconnected = "Disconnected";
          #label-disconnected-foreground = ${colors.secondary}

          ramp-signal-0 = "0";
          ramp-signal-1 = "1";
          ramp-signal-2 = "2";
          ramp-signal-3 = "3";
          ramp-signal-4 = "4";
          ramp-signal-foreground = "\${colors.foreground-alt}";
        };
      };
    };
    programs.rofi = {
      enable = true;
      plugins = with pkgs; [
        pkgs.rofi-calc
      ];
      font = "JetBrainsMono Nerd Font 10";
      extraConfig = {
        show-icons = true;
        icon-theme = "Papirus";
        display-drun = "";
        drun-display-format = "{name}";
        disable-history = false;
        sidebar-mode = false;
      };
      theme = let
        inherit (config.lib.formats.rasi) mkLiteral;
      in
      {
        # this is taken from adi1090x/rofi
        # 1080p/launchers/colorful/style_1.rasi
        "*" = with colors.dark; {
          al = mkLiteral "#00000000";
          bg = mkLiteral "#${base00}ff";
          fg = mkLiteral "#${base05}ff";
          se = mkLiteral "#${base02}ff";
          ac = mkLiteral "#${base09}ff";
        };
        window = {
          transparency = "real";
          background-color = mkLiteral "@bg";
          text-color = mkLiteral "@fg";
          border = mkLiteral "0px";
          border-color = mkLiteral "@ac";
          border-radius = mkLiteral "12px";
          width = mkLiteral "35%";
          location = mkLiteral "center";
          x-offset = 0;
          y-offset = 0;
        };
        prompt = {
          enabled = true;
          padding = mkLiteral "0.30% 1% 0% -0.5%";
          background-color = mkLiteral "@al";
          text-color = mkLiteral "@bg";
          font = "JetBrainsMono Nerd Font 12";
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
          columns = 5;
          lines = 3;
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
          children = map mkLiteral ["inputbar" "listview"];
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
          frame_color = "#${colors.dark.base00}";
        };
        urgency_low = with colors.dark; {
          background = "#${base01}";
          foreground = "#${base05}";
        };
        urgency_normal = with colors.dark; {
          background = "#${base01}";
          foreground = "#${base05}";
        };
        urgency_critical = with colors.dark; {
          background = "#${base01}";
          foreground = "#${base08}";
          frame_color = "#${base08}";
        };
      };
    };
    services.xscreensaver = {
      enable = true;
      settings = {
        # TODO: this shit doesn't fucking work
        /* lock = true; */
        /* mode = "blank"; */
        /* dialogTheme = "darkgray"; */
        /* lockTimeout = 1; */
      };
    };
  };
}
