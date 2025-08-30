# profiles/home/waybar.nix
#
# Author: João Borges <RageKnify@gmail.com>
# URL:    https://github.com/RageKnify/Config
#
# waybar configuration

{
  pkgs,
  config,
  lib,
  myLib,
  ...
}:
{
  programs.waybar = {
    enable = true;
    systemd.enable = true;
    settings = {
      mainBar = {
        modules-left = [
          "niri/language"
          "pulseaudio"
        ];
        modules-right = [
          "cpu"
          "temperature"
          "memory"
          "network"
          "battery"
          "clock"
          "tray"
        ];
        "niri/language" = {
          format = " {short} {variant}";
          on-click = "niri msg action switch-layout next";
        };
        pulseaudio = {
          format = "{icon} {volume}%";
        };
        cpu = {
          format = " {usage:2}%";
          tooltip = false;
        };
        temperature = {
          # "thermal-zone": 2,
          hwmon-path = "/sys/class/thermal/thermal_zone9/temp";
          critical-threshold = 80;
          # "format-critical": "{temperatureC}°C {icon}",
          format = "{icon} {temperatureC}°C";
          format-icons = [
            ""
            ""
            ""
            ""
            ""
          ];
        };
        memory = {
          format = " {}%";
        };
        network = {
          format-wifi = "  {essid} ({signalStrength}%)";
          format-etherne = "  {ipaddr}/{cidr}";
          tooltip-forma = "  {ifname} via {gwaddr}";
          format-linke = "  {ifname} (No IP)";
          format-disconnected = "⚠ Disconnected";
          format-alt = "{ifname}: {ipaddr}/{cidr}";
        };
        battery = {
          states = {
            warning = 30;
            critical = 15;
          };
          format = "{icon} {capacity}%";
          format-full = "{icon} {capacity}%";
          format-charging = " {capacity}%";
          format-plugged = " {capacity}%";
          format-icons = [
            ""
            ""
            ""
            ""
            ""
          ];
        };
        clock = {
          tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
          format = " {:%H:%M}";
          format-alt = " {:%Y-%m-%d}";
        };
      };
    };
    style = with myLib.colors.dark; ''
      @define-color bg ${base00};
      @define-color lighterbg ${base01};
      @define-color fg ${base05};
      @define-color darkfg ${base04};
      @define-color red ${base08};
      @define-color orange ${base09};
      @define-color yellow ${base0A};
      @define-color green ${base0B};
      @define-color aqua ${base0C};
      @define-color blue ${base0D};
      @define-color purple ${base0E};

      * {
        font-family: monospace;
        font-size: 16px;
        min-height: 0;
        padding: 0;
        margin: 0;
        color: @fg;
        background-color: @bg;
      }

      #language {
        border-top: 3px solid @yellow;
        padding-left: 5px;
        margin-left: 5px;
      }

      #pulseaudio {
        border-top: 3px solid @blue;
        padding-left: 5px;
        margin-left: 5px;
      }

      #cpu {
        border-top: 3px solid @purple;
        padding-right: 5px;
        margin-right: 5px;
      }

      #temperature {
        border-top: 3px solid @orange;
        padding-right: 5px;
        margin-right: 5px;
      }

      #memory {
        border-top: 3px solid @aqua;
        padding-right: 5px;
        margin-right: 5px;
      }

      #network {
        border-top: 3px solid @green;
        padding-right: 5px;
        margin-right: 5px;
      }

      #battery {
        border-top: 3px solid @yellow;
        padding-right: 5px;
        margin-right: 5px;
      }

      #battery.warning:not(.charging) {
        border-bottom: 3px solid @orange;
      }

      #battery.critical:not(.charging) {
        border-bottom: 3px solid @red;
      }

      #clock {
        border-top: 3px solid @red;
        padding-right: 5px;
        margin-right: 5px;
      }
    '';
  };
}
