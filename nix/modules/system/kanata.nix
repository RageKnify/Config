# modules/system/kanata.nix
#
# Author: João Borges <RageKnify@gmail.com>
# URL:    https://github.com/RageKnify/Config
#
# Enable kanata to have Colemak-dh
{ pkgs, config, lib, ... }:
let
  inherit (lib) mkEnableOption mkOption types mkIf;
  cfg = config.modules.kanata;
in
{
  options.modules.kanata = {
    enable = mkEnableOption "kanata";
    normal_device = mkOption { type = types.str; };
  };

  config = mkIf cfg.enable {
    services.kanata = {
      enable = true;
      keyboards = {
        default_keyboard = {
          devices = [
            cfg.normal_device
          ];
          config = ''
  (defsrc
    esc
    grv  1    2    3    4    5    6    7    8    9    0    -    =    bspc
    tab  q    w    e    r    t    y    u    i    o    p    [    ]    ret
    caps a    s    d    f    g    h    j    k    l    ;    '    bksl
    lsft lsgt z    x    c    v    b    n    m    ,    .    /    rsft
    lctl lmet lalt                spc            ralt sys  rctl
  )

  (defalias
    cte (tap-hold-press 200 200 esc lctl)
    ;; tap: backtick (grave), hold: toggle layer-switching layer while held
    ;; use it as a modifier, hold grv and then press 1 or 2
    grl (tap-hold 200 200 grv (layer-toggle layers))

    qwr (layer-switch qwerty)
    clk (layer-switch colemak-dh)
  )


  (deflayer colemak-dh
    @cte
    @grl  _    _    _    _    _    _    _    _    _    _    _    _    _
    _     q    w    f    p    b    j    l    u    y    ;    _    _    _
    @cte  a    r    s    t    g    m    n    e    i    o    _    _
    _     z    x    c    d    v    lsgt k    h    _    _    _    _
    @cte  _    _              _              _    _    _
  )


  (deflayer colemak-dh-wide
    @cte
    @grl  1    2    3    4    5    6    =    7    8    9    0    -    _
    _     q    w    f    p    b    [    j    l    u    y    ;    '    _
    @cte  a    r    s    t    g    ]    m    n    e    i    o    _
    _     z    x    c    d    v    lsgt /    k    h    ,    .    _
    @cte  _    _              _              _    _    _
  )


  (deflayer qwerty
    _
    @grl  _    _    _    _    _    _    _    _    _    _    _    _    _
    _     _    _    _    _    _    _    _    _    _    _    _    _    _
    _     _    _    _    _    _    _    _    _    _    _    _    _
    _     _    _    _    _    _    _    _    _    _    _    _    _
    _     _    _                   _         _    _    _
  )


  (deflayer layers
    _
    _    @qwr @clk _    _    _    _    _    _    _    _    _    _    _
    _    _    _    _    _    _    _    _    _    _    _    _    _    _
    _    _    _    _    _    _    _    _    _    _    _    _    _
    _    _    _    _    _    _    _    _    _    _    _    _    _
    _    _    _              _              _    _    _
  )
          '';
        };
      };
    };
  };
}
