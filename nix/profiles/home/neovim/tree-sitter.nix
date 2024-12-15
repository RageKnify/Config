{
  personal,
  nvim-treesitter,
  lists,
  tree-sitter-jinja2,
}:
let
  grammars =
    with nvim-treesitter.builtGrammars;
    [
      tree-sitter-bash
      tree-sitter-comment
      tree-sitter-html
      tree-sitter-markdown
      tree-sitter-python
    ]
    ++ (lists.optionals personal [
      tree-sitter-nix
      tree-sitter-c
      tree-sitter-cpp
      tree-sitter-java
      tree-sitter-javascript
      tree-sitter-jinja2
      tree-sitter-latex
      tree-sitter-lua
      tree-sitter-ocaml
      tree-sitter-ocaml-interface
      tree-sitter-rust
      tree-sitter-scheme
      tree-sitter-toml
      tree-sitter-typescript
      tree-sitter-vim
      tree-sitter-yaml
    ]);
in
{
  plugin = (nvim-treesitter.withPlugins (plugins: grammars));
  type = "lua";
  # TODO: use injections for salt
  #  https://www.reddit.com/r/neovim/comments/v9e85n/what_do_you_use_treesitter_for_other_than/ibwbro1/?context=10000
  #  require('vim.treesitter.query').set(
  #  'yaml',
  #  'injections',
  #  [[
  #  ((
  #    (raw_string_literal) @constant
  #    (#match? @constant "(\{\{|\{%).*")
  #  ) @injection.content (#set! injection.language "jinja2"))
  #  ]]
  #  )
  config = ''
    -- enable highlighting
    require'nvim-treesitter.configs'.setup { highlight = { enable = true } }

    local function define_fdm()
      if (require "nvim-treesitter.parsers".has_parser()) then
        -- with treesitter parser
        vim.wo.foldexpr="nvim_treesitter#foldexpr()"
        vim.wo.foldmethod="expr"
      else
        -- without treesitter parser
        vim.wo.foldmethod="syntax"
      end
    end
    vim.api.nvim_create_autocmd({ "FileType" }, { callback = define_fdm })
  '';
}
