{
  pkgs,
  fetchFromGitHub,
  ...
}:
let
  version = "9ed363e15aac29f86c70a432514462694e6e0923";
in
pkgs.tree-sitter.buildGrammar {
  inherit version;
  language = "jinja2";
  src = fetchFromGitHub {
    owner = "dbt-labs";
    repo = "tree-sitter-jinja2";
    rev = "${version}";
    hash = "sha256-nYv30mSi+xTTNtZtMAcuKUfRyH1UtxOmuqKS02Ax1B4=";
  };
  meta.homepage = "https://github.com/dbt-labs/tree-sitter-jinja2";
}
