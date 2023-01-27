# modules/system/kmonad.nix
#
# Author: João Borges <RageKnify@gmail.com>
# URL:    https://github.com/RageKnify/Config
#
# Enable kmonad to have Colemak-dh
{ pkgs, config, lib, ... }:
let
  inherit (lib) mkEnableOption mkOption types mkIf;
  cfg = config.modules.kmonad;
in
{
  options.modules.kmonad = {
    enable = mkEnableOption "kmonad";
    normal_device = mkOption { type = types.str; };
  };

  config = mkIf cfg.enable {
    services.kmonad = {
      enable = true;
      keyboards = {
        default_keyboard = {
          name = "default_keyboard";
          device = cfg.normal_device;
          defcfg = {
            enable = true;
            fallthrough = true;
            allowCommands = false;
          };
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
    cte (tap-hold-next 500 esc lctl)
  )

  (deflayer colemak-dh
    @cte
    grv  1    2    3    4    5    6    7    8    9    0    -    =    bspc
    tab  q    w    f    p    b    j    l    u    y    ;    [    ]    ret
    @cte a    r    s    t    g    m    n    e    i    o    '    bksl
    lsft z    x    c    d    v    lsgt k    h    ,    .    /    rsft
    @cte lmet lalt                spc            ralt prnt rctl
  )
          '';
        };
      };
    };
  };
}
