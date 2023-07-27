# profiles/home/sxhkd.nix
#
# Author: João Borges <RageKnify@gmail.com>
# URL:    https://github.com/RageKnify/Config
#
# sxhkd configuration

{ pkgs, config, lib, osConfig, myLib, ... }:
let
  inherit (lib) mkEnableOption mkIf attrsets;
  inherit (attrsets) optionalAttrs;
  laptop = osConfig.modules.laptop;
  light = osConfig.programs.light;
  colors = myLib.colors;
  sxhkdMod = "mod4";
in {
  xsession.windowManager.i3.config.startup = [{
    command = "sxhkd";
    notification = false;
  }];
  services.sxhkd = {
    enable = true;
    keybindings = {
      # power menu
      "${sxhkdMod}+x" = "${pkgs.power_menu}/bin/power_menu.sh";

      # open a DnD book pdf
      "${sxhkdMod}+z" = "${pkgs.dnd_book}/bin/dnd_book.sh";

      # rofi-calc
      "${sxhkdMod}+p" =
        "rofi -show calc -modi calc -no-show-match -no-sort -theme $XDG_DATA_HOME/rofi/themes/calc";

      # flameshot
      "${sxhkdMod}+Print" = "flameshot gui";
    } // optionalAttrs laptop.enable {
      # sound toggle
      "XF86AudioMute" = "pactl set-sink-mute @DEFAULT_SINK@ toggle";

      # volume up
      "XF86AudioRaiseVolume" = "pactl set-sink-volume @DEFAULT_SINK@ +5%";

      # volume down
      "XF86AudioLowerVolume" = "pactl set-sink-volume @DEFAULT_SINK@ -5%";

      # mic toggle
      "XF86AudioMicMute" = "pactl set-source-mute 0 toggle";
    } // optionalAttrs light.enable {
      # brightness up
      "XF86MonBrightnessUp" = "light -A 10";

      # brightness down
      "XF86MonBrightnessDown" = "light -U 10";
    };
  };
  services.flameshot = {
    enable = true;
    settings = {
      General = {
        disabledTrayIcon = true;
        showStartupLaunchMessage = false;
      };
    };
  };
  # for access to pactl
  home.packages = [ pkgs.pulseaudio ];
  # TODO: power_menu.sh assumes this exists, not sure how to handle since this uses the base16 colors
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
}
