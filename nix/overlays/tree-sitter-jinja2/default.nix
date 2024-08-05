# overlays/tree-sitter-jinja2.nix
#
# Author: João Borges <RageKnify@gmail.com>
# URL:    https://github.com/RageKnify/Config
#
# Add tree-sitter-jinja2 as an overlay so it is accessible from home manager

{ ... }:
let
  version = "9ed363e15aac29f86c70a432514462694e6e0923";
in
final: prev: rec {
  mypkgs.tree-sitter-jinja2 = prev.tree-sitter.buildGrammar {
    inherit version;
    language = "jinja2";
    src = prev.fetchFromGitHub {
      owner = "dbt-labs";
      repo = "tree-sitter-jinja2";
      rev = "${version}";
      hash = "sha256-nYv30mSi+xTTNtZtMAcuKUfRyH1UtxOmuqKS02Ax1B4=";
    };
    meta.homepage = "https://github.com/dbt-labs/tree-sitter-jinja2";
  };
}
