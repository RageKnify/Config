# profiles/home/niri.nix
#
# Author: João Borges <RageKnify@gmail.com>
# URL:    https://github.com/RageKnify/Config
#
# niri configuration

{
  pkgs,
  config,
  lib,
  osConfig,
  profiles,
  myLib,
  ...
}:
let
  nixos = osConfig.networking.hostName != "death";
  swaylockPath = if nixos then "${pkgs.swaylock}/bin/swaylock" else "/usr/bin/swaylock";
  niriPath = if nixos then lib.getExe config.programs.niri.package else "/usr/local/bin/niri";
in
{
  home.packages = with pkgs; [
    wl-clipboard
    wlr-randr
    wayland-utils
    libsecret
    cage
    gamescope
    xwayland-satellite-unstable
    swaylock
  ];

  programs.niri.settings = {

    screenshot-path = "~/documents/pictures/screenshots/%Y-%m-%dT%H-%M-%S.png";

    prefer-no-csd = true;

    environment = {
      NIXOS_OZONE_WL = "1";
    };

    layout = {
      always-center-single-column = true;
      empty-workspace-above-first = true;
      gaps = 0;
      focus-ring.enable = false;
    };

    gestures = {
      hot-corners.enable = false;
    };

    input = {
      keyboard = {
        repeat-delay = 300;
        xkb = {
          model = "pc104";
          layout = "us,us(intl)";
          options = "grp:win_space_toggle";
        };
      };
    };

    binds =
      let
        binds =
          {
            suffixes,
            prefixes,
            substitutions ? { },
          }:
          let
            replacer = lib.replaceStrings (builtins.attrNames substitutions) (
              builtins.attrValues substitutions
            );
            format =
              prefix: suffix:
              let
                actual-suffix =
                  if builtins.isList suffix.action then
                    {
                      action = builtins.head suffix.action;
                      args = builtins.tail suffix.action;
                    }
                  else
                    {
                      inherit (suffix) action;
                      args = [ ];
                    };

                action = replacer "${prefix.action}-${actual-suffix.action}";
              in
              {
                name = "${prefix.key}+${suffix.key}";
                value.action.${action} = actual-suffix.args;
              };
            pairs =
              attrs: fn:
              builtins.concatMap (
                key:
                fn {
                  inherit key;
                  action = attrs.${key};
                }
              ) (builtins.attrNames attrs);
          in
          builtins.listToAttrs (pairs prefixes (prefix: pairs suffixes (suffix: [ (format prefix suffix) ])));
      in
      with config.lib.niri.actions;
      lib.attrsets.mergeAttrsList [
        {
          "Mod+Shift+Slash".action = show-hotkey-overlay;
          "Mod+Shift+E".action = quit;
          "Mod+D" = {
            action = spawn [
              "${pkgs.rofi}/bin/rofi"
              "-matching"
              "normal"
              "-modi"
              "drun"
              "-show"
              "drun"
            ];
            hotkey-overlay.title = "Spawn rofi";
          };
          "Mod+Shift+X" = {
            action = spawn [
              "loginctl"
              "lock-session"
            ];
            hotkey-overlay.title = "Lock the session";
          };
          "Mod+Return".action = spawn "kitty";
          "Mod+O".action = toggle-overview;
          "Mod+Q".action = close-window;

          "Mod+BracketLeft".action = consume-or-expel-window-left;
          "Mod+BracketRight".action = consume-or-expel-window-right;
          "Mod+Comma".action = consume-window-into-column;
          "Mod+Period".action = expel-window-from-column;

          "Mod+R".action = switch-preset-column-width;
          "Mod+Shift+R".action = switch-preset-window-height;
          "Mod+F".action = maximize-column;
          "Mod+Shift+F".action = fullscreen-window;
          "Mod+C".action = center-column;

          "Mod+V".action = switch-focus-between-floating-and-tiling;
          "Mod+Shift+V".action = toggle-window-floating;

          "Mod+Minus".action = set-column-width "-10%";
          "Mod+Equal".action = set-column-width "+10%";
          "Mod+Shift+Minus".action = set-window-height "-10%";
          "Mod+Shift+Equal".action = set-window-height "+10%";

          "Mod+Print".action.screenshot-screen = {};

          # Brightness - logarithmic scale
          "XF86MonBrightnessDown".action.spawn-sh = "${pkgs.light}/bin/light -T 0.618";
          "XF86MonBrightnessUp".action.spawn-sh = "${pkgs.light}/bin/light -T 1.618";

          # Audio - logarithmic scale
          "XF86AudioLowerVolume".action.spawn-sh =
            "${pkgs.pulseaudio}/bin/pactl set-sink-volume @DEFAULT_SINK@ -2dB";
          "XF86AudioRaiseVolume".action.spawn-sh =
            "${pkgs.pulseaudio}/bin/pactl set-sink-volume @DEFAULT_SINK@ +2dB";
          "XF86AudioMute".action.spawn-sh = "${pkgs.pamixer}/bin/pamixer -t";
          "XF86AudioMicMute".action.spawn-sh = "${pkgs.pamixer}/bin/pamixer --default-source -t";
        }
        (binds {
          suffixes."Home" = "first";
          suffixes."End" = "last";
          prefixes."Mod" = "focus-column";
          prefixes."Mod+Shift" = "move-column-to";
        })
        (binds {
          suffixes."Left" = "column-left";
          suffixes."Down" = "window-or-workspace-down";
          suffixes."Up" = "window-or-workspace-up";
          suffixes."Right" = "column-right";

          suffixes."H" = "column-left";
          suffixes."J" = "window-or-workspace-down";
          suffixes."K" = "window-or-workspace-up";
          suffixes."L" = "column-right";

          prefixes."Mod" = "focus";
        })
        (binds {
          suffixes."Left" = "column-left";
          suffixes."Down" = "window-down-or-to-workspace-down";
          suffixes."Up" = "window-up-or-to-workspace-up";
          suffixes."Right" = "column-right";

          suffixes."H" = "column-left";
          suffixes."J" = "window-down-or-to-workspace-down";
          suffixes."K" = "window-up-or-to-workspace-up";
          suffixes."L" = "column-right";

          prefixes."Mod+Shift" = "move";
        })
      ];
  };

  services.kanshi = {
    enable = true;

    settings = [
      {
        profile = {
          name = "undocked";
          outputs = [
            {
              criteria = "eDP-1";
              scale = if nixos then 1.0 else 2.0;
            }
          ];
        };
      }
      {
        profile = {
          name = "docked";
          outputs = [
            {
              criteria = "eDP-1";
              scale = if nixos then 1.0 else 2.0;
            }
            {
              criteria = "DP-1";
              scale = 2.0;
            }
          ];
        };
      }
    ];
  };

  services.gammastep = {
    enable = true;
    temperature = {
      day = 3500;
      night = 2500;
    };
    latitude = 38.4;
    longitude = -9.8;
  };

  programs.swaylock = {
    enable = true;
    settings = {
      color = myLib.colors.dark.base00;
      line-color = myLib.colors.dark.base05;
    };
  };

  services.swayidle = {
    enable = true;
    events = [
      {
        event = "lock";
        command = "${swaylockPath} -fF";
      }
      {
        event = "before-sleep";
        command = "${swaylockPath} -fF && ${niriPath} msg action power-off-monitors";
      }
      {
        event = "after-resume";
        command = "${niriPath} msg action power-on-monitors";
      }
    ];
    timeouts = [
      {
        timeout = 600;
        command = "${swaylockPath} -fF";
      }
      {
        timeout = 610;
        command = "${niriPath} msg action power-off-monitors";
        resumeCommand = "${niriPath} msg action power-on-monitors";
      }
    ];
  };

  services.wpaperd = {
    enable = true;

    settings = {
      any = {
        path = "${./../nixos/graphical/wallpapers}/${osConfig.networking.hostName}";
        duration = "10m";
        recursive = false;
      };
    };
  };
}
