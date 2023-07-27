# modules/home/graphical/polybar.nix
#
# Author: João Borges <RageKnify@gmail.com>
# URL:    https://github.com/RageKnify/Config
#
# polybar configuration.

{ pkgs, config, lib, hostName, osConfig, myLib, ... }:
let
  inherit (lib) mkEnableOption mkIf mkForce strings attrsets;
  inherit (attrsets) optionalAttrs;
  cfg = config.modules.graphical.polybar;
  i3 = config.modules.graphical.i3.enable;
  laptop = osConfig.modules.laptop;
  colors = myLib.colors;
in {
  options.modules.graphical.polybar.enable = mkEnableOption "polybar";

  config = mkIf cfg.enable {
    services.polybar = {
      enable = true;
      script = ''
        for m in $(${pkgs.xorg.xrandr}/bin/xrandr --query | ${pkgs.gnugrep}/bin/grep " connected" | ${pkgs.coreutils}/bin/cut -d" " -f1); do
          MONITOR=$m polybar --reload bar&
        done
      '';
      package = (pkgs.polybar.override {
        i3Support = i3;
        pulseSupport = true;
      });
      settings = with colors.dark; {
        colors = {
          background = "${base00}";
          background-alt = "${base01}";
          foreground = "${base05}";
          foreground-alt = "${base06}";
          primary = "${base09}";
          secondary = "${base0A}";
          alert = "${base08}";
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
            "DejaVu Mono:pixelsize=14;4"
            "DejaVu Mono:style=bold:pixelsize=14;4"
            "Font Awesome 6 Free:style=regular;4"
            "Font Awesome 6 Free:style=solid;4"
            "Font Awesome 6 Brands,Font Awesome 6 Brands Regular:style=Regular;4"
          ];
          tray-position = "right";
          tray-padding = 1;
          padding = 0;
          bottom = false;
          monitor = "\${env:MONITOR:eDP-1}";
          modules-left = (strings.optionalString i3 "i3 ")
            + "xkeyboard pulseaudio";
          # modules-right = filesystem0 filesystem1 cpu temperature memory wlan battery date
          modules-right = "cpu temperature memory"
            + (strings.optionalString laptop.enable " wlan battery") + " date";
        };
        "module/i3" = optionalAttrs i3 {
          type = "internal/i3";
          format = "<label-state> <label-mode>";
          index-sort = true;
          wrapping-scroll = false;
          label-mode-padding = 2;
          label-mode-foreground = "#000";
          label-mode-background = "\${colors.primary}";

          # focused = Active workspace on focused monitor
          label-focused = "%name%";
          label-focused-background = "\${colors.background-alt}";
          label-focused-overline = "\${colors.primary}";
          label-focused-padding = 2;
          label-focused-font = 2;

          # unfocused = Inactive workspace on any monitor
          label-unfocused = "%name%";
          label-unfocused-padding = 2;
          label-unfocused-font = 2;

          # visible = Active workspace on unfocused monitor
          label-visible = "%name%";
          label-visible-background = "\${self.label-focused-background}";
          label-visible-overline = "\${self.label-focused-overline}";
          label-visible-padding = "\${self.label-focused-padding}";
          label-visible-font = 2;

          # urgent = Workspace with urgency hint set
          label-urgent = "%name%";
          label-urgent-background = "\${colors.alert}";
          label-urgent-padding = 2;
          label-urgent-font = 2;
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
          format-overline = "${base0E}";
          label = "%percentage%%";
        };
        "module/temperature" = {
          type = "internal/temperature";
          thermal-zone = "4";
          warn-temperature = 60;

          format = "<ramp> <label>";
          format-overline = "${base0E}";
          format-warn = "<ramp> <label-warn>";
          format-warn-overline = "\${self.format-overline}";

          label = "%temperature-c%";
          label-warn = "%temperature-c%";
          label-warn-foreground = "${base08}";

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
          format-overline = "${base0C}";
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
          format-overline = "${base08}";
          label = "%date% %time%";
        };
        "module/pulseaudio" = {
          type = "internal/pulseaudio";
          sink = "alsa_output.pci-0000_00_1f.3.analog-stereo";
        };
        "module/battery" = optionalAttrs laptop.enable {
          type = "internal/battery";
          battery = laptop.battery;
          adapter = laptop.adapter;
          full-at = 100;
          time-format = "%H:%M";

          format-charging = "<animation-charging> <label-charging>";
          label-charging = "%percentage%%";
          format-charging-overline = "${base0A}";

          format-discharging = "<ramp-capacity> <label-discharging>";
          label-discharging = "%percentage%%";
          format-discharging-overline = "\${self.format-charging-overline}";

          low-at = 10;
          format-low = "<animation-low> <ramp-capacity> <label-discharging>";
          format-low-overline = "\${self.format-charging-overline}";

          animation-low-0 = ".";
          animation-low-1 = "!";

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
        "module/wlan" = optionalAttrs laptop.enable {
          type = "internal/network";
          interface = laptop.wlan_interface;
          interval = 3.0;
          format-connected-prefix = " ";
          format-disconnected-prefix = "\${self.format-connected-prefix}";
          format-connected-prefix-foreground = "\${colors.foreground-alt}";
          format-disconnected-prefix-foreground = "\${colors.foreground-alt}";

          format-connected = "<ramp-signal> <label-connected>";
          format-connected-overline = "${base0B}";
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
  };
}
