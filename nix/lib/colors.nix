{ ... }:
let
  colors = {
    dark = {
      "base00" = "#002b36"; # background
      "base01" = "#073642"; # lighter background
      "base02" = "#586e75"; # selection background
      "base03" = "#657b83"; # comments, invisibles, line highlighting
      "base04" = "#839496"; # dark foreground
      "base05" = "#93a1a1"; # default foreground
      "base06" = "#eee8d5"; # light foreground
      "base07" = "#fdf6e3"; # light background
      "base08" = "#dc322f"; # red       variables
      "base09" = "#cb4b16"; # orange    integers, booleans, constants
      "base0A" = "#b58900"; # yellow    classes
      "base0B" = "#859900"; # green     strings
      "base0C" = "#2aa198"; # aqua      support, regular expressions
      "base0D" = "#268bd2"; # blue      functions, methods
      "base0E" = "#6c71c4"; # purple    keywords, storage, selector
      "base0F" = "#d33682"; # deprecated, opening/closing embedded language tags
    };
    light = {
      "base00" = "#fdf6e3";
      "base01" = "#eee8d5";
      "base02" = "#93a1a1";
      "base03" = "#839496";
      "base04" = "#657b83";
      "base05" = "#586e75";
      "base06" = "#073642";
      "base07" = "#002b36";
      "base08" = "#dc322f";
      "base09" = "#cb4b16";
      "base0A" = "#b58900";
      "base0B" = "#859900";
      "base0C" = "#2aa198";
      "base0D" = "#268bd2";
      "base0E" = "#6c71c4";
      "base0F" = "#d33682";
    };
  };
in
{
  inherit colors;

  hostNameToColor =
    hostName:
    let
      mapping = {
        war = "base08";
        azazel = "base0E";
        conquest = "base0F";
        death = "base09";
      };
      base = mapping."${hostName}";
    in
    colors.light."${base}";
}
