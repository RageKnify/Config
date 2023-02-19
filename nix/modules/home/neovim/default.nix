# modules/home/neovim.nix
#
# Author: João Borges <RageKnify@gmail.com>
# URL:    https://github.com/RageKnify/Config
#
# neovim home configuration.

{ pkgs, config, lib, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.modules.neovim;
  personal = config.modules.personal.enable;
  git = config.modules.shell.git.enable;
  commonPlugins = with pkgs.unstable.vimPlugins; [
    nvim-web-devicons
    {
      plugin = lualine-nvim;
      type = "lua";
      config = ''
vim.o.laststatus=2
vim.o.showtabline=2
vim.o.showmode=false
require'lualine'.setup {
  options = {
    theme = 'auto',
    section_separators = {left='', right=''},
    component_separators = {left='', right=''},
    icons_enabled = true
  },
  sections = {
    lualine_b = { '' + (if git then "'diff'" else "")+ '' },
    lualine_c = {
      {'diagnostics', {
        sources = {nvim_diagnostic},
        symbols = {error = ':', warn =':', info = ':', hint = ':'}}},
      {'filename', file_status = true, path = 1}
    },
    lualine_x = { 'encoding', {'filetype', colored = false} },
  },
  inactive_sections = {
    lualine_c = {
      {'filename', file_status = true, path = 1}
    },
    lualine_x = { 'encoding', {'filetype', colored = false} },
  },
  tabline = {
    lualine_a = { 'hostname' },
    lualine_b = { '' + (if git then "'branch'" else "")+ '' },
    lualine_z = { {'tabs', tabs_color = { inactive = "TermCursor", active = "ColorColumn" } } }
  },
  extensions = { fzf'' + (if git then ", fugitive " else "") + ''},
}
if _G.Tabline_timer == nil then
  _G.Tabline_timer = vim.loop.new_timer()
else
  _G.Tabline_timer:stop()
end
_G.Tabline_timer:start(0,             -- never timeout
                       100,          -- repeat every 1000 ms
                       vim.schedule_wrap(function() -- updater function
                                            vim.api.nvim_command('redrawtabline')
                                         end))
      '';
    }

    {
      plugin = delimitMate;
      config = ''
      let delimitMate_expand_cr=2
      let delimitMate_expand_space=1
      '';
    }

    {
      plugin = vim-illuminate;
      config = ''
      let g:Illuminate_delay = 100
      hi def link LspReferenceText CursorLine
      hi def link LspReferenceRead CursorLine
      hi def link LspReferenceWrite CursorLine
      '';
    }

    (import ./tree-sitter.nix {
      inherit personal;
      nvim-treesitter = pkgs.unstable.vimPlugins.nvim-treesitter;
    })

    vim-signature

    {
      plugin = fzf-lua;
      type = "lua";
      config = ''
local fzf_lua = require('fzf-lua')
fzf_lua.setup{
  fzf_opts = {
    ['--layout'] = 'reverse',
  },
  winopts = {
    height = 0.75,
    width = 0.75,
  },
}

local set = vim.keymap.set

local files = function()
  vim.fn.system('git rev-parse --is-inside-work-tree')
  if vim.v.shell_error == 0 then
    fzf_lua.git_files()
  else
    fzf_lua.files()
  end
end

-- fuzzy find files in the working directory (where you launched Vim from)
set('n', '<leader>f', files)

-- fuzzy find lines in the current file
set('n', '<leader>/', fzf_lua.blines)

-- fuzzy find an open buffer
set('n', '<leader>b', fzf_lua.buffers)

-- fuzzy find text in the working directory
set('n', '<leader>rg', fzf_lua.grep_project)

-- fuzzy find Vim commands (like Ctrl-Shift-P in Sublime/Atom/VSC)
set('n', '<leader>c', fzf_lua.commands)
      '';
    }

    vim-commentary

    {
      plugin = nvim-base16;
      config = ''
      " colorscheme settings
      set background=light
      colorscheme base16-solarized-light
      '';
    }

    plenary-nvim

    {
      plugin = pkgs.nvim-osc52;
      type = "lua";
      config = ''
local function copy(lines, _)
  require('osc52').copy(table.concat(lines, '\n'))
end

local function paste()
  return {vim.fn.split(vim.fn.getreg(""), '\n'), vim.fn.getregtype("")}
end

vim.g.clipboard = {
  name = 'osc52',
  copy = {['+'] = copy, ['*'] = copy},
  paste = {['+'] = paste, ['*'] = paste},
}

-- Now the '+' register will copy to system clipboard using OSC52
vim.keymap.set('n', '<leader>y', '"+y')
vim.keymap.set('x', '<leader>y', '"+y')
      '';
    }

    {
      plugin = nvim-colorizer-lua;
      type = "lua";
      config = ''
require 'colorizer'.setup ({ user_default_options = { names = false; }})
      '';
    }
  ];
  personalPlugins = if personal then with pkgs.unstable.vimPlugins; [
    {
      plugin = nvim-lspconfig;
      type = "lua";
      config = ''
-- common lsp setup
local lsp_config = require'lspconfig'
local lsp_setup = require'generic_lsp'

-- ocaml lsp setup
lsp_config.ocamllsp.setup(lsp_setup)

-- Rust lsp setup
local rt = require("rust-tools")

local capabilities = lsp_setup.capabilities
local on_attach = lsp_setup.on_attach
rt.setup({
  server = {
    capabilities = capabilities,
    on_attach = function(_, bufnr)
      -- Hover actions
      on_attach(_, bufnr)
      vim.keymap.set('n', 'K', rt.hover_actions.hover_actions, {silent=true})
    end,
    settings = {
      ["rust-analyzer"] = {
        checkOnSave = {
          command = "clippy",
        },
      },
    },
  },
})

-- tex lsp setup
lsp_config.texlab.setup(lsp_setup)
      '';
    }
    rust-tools-nvim

    {
      plugin = presence-nvim;
      config = ''
      let g:presence_auto_update       = 1
      let g:presence_editing_text      = "Editing %s"
      let g:presence_workspace_text    = "Working on %s"
      let g:presence_neovim_image_text = "vim but better"
      let g:presence_main_image        = "neovim"
      '';
    }

    luasnip
    {
      plugin = nvim-cmp;
      type = "lua";
      config = ''
-- Setup nvim-cmp.
local cmp = require'cmp'

cmp.setup({
  snippet = {
    -- REQUIRED - you must specify a snippet engine
    expand = function(args)
      require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
    end,
  },
  window = {
    -- completion = cmp.config.window.bordered(),
    -- documentation = cmp.config.window.bordered(),
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
    { name = 'treesitter' },
    { name = 'spell' },
    { name = 'path' },
    { name = 'buffer' },
  })
})

-- autocomplete commits, Issue/PR numbers, mentions
cmp.setup.filetype('gitcommit', {
  sources = cmp.config.sources({
    { name = 'git' },
    { name = 'spell' },
    { name = 'buffer' },
  })
})

-- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline('/', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = 'buffer' },
  }
})
      '';
    }
    cmp_luasnip
    cmp-treesitter
    cmp-nvim-lsp
    cmp-spell
    cmp-path
    cmp-git
  ] else [];
  twoSpaceIndentConfig = ''
setlocal shiftwidth=2
setlocal softtabstop=2
setlocal tabstop=2
setlocal expandtab
'';
in
{
  options.modules.neovim.enable = mkEnableOption "neovim";

  config = mkIf cfg.enable {
    programs.neovim = {
      package = pkgs.unstable.neovim-unwrapped;
      enable = true;
      viAlias = true;
      vimAlias = true;
      vimdiffAlias = true;
      extraConfig = builtins.readFile ./base.vim;
        plugins = commonPlugins ++ personalPlugins ++ (
          if git then with pkgs.unstable.vimPlugins; [
            vim-fugitive
            {
              plugin = gitsigns-nvim;
              type = "lua";
              config = ''
require('gitsigns').setup{
  signs = {
    add = {  text = '+' },
  },
  on_attach = function(bufnr)
    local gs = package.loaded.gitsigns

    local function map(mode, l, r, opts)
      opts = opts or {}
      opts.buffer = bufnr
      vim.keymap.set(mode, l, r, opts)
    end

    map('n', '<leader>gb', gs.toggle_current_line_blame)
  end,
}
              '';
            }
          ] else []
        );
    };

    # languages that should use 2 space indent
    home.file."${config.xdg.configHome}/nvim/after/ftplugin/markdown.vim".text = twoSpaceIndentConfig;
    home.file."${config.xdg.configHome}/nvim/after/ftplugin/nix.vim".text = twoSpaceIndentConfig;
    home.file."${config.xdg.configHome}/nvim/after/ftplugin/ocaml.vim".text = twoSpaceIndentConfig;
    home.file."${config.xdg.configHome}/nvim/after/ftplugin/wast.vim".text = twoSpaceIndentConfig;
    home.file."${config.xdg.configHome}/nvim/after/ftplugin/yaml.vim".text = twoSpaceIndentConfig;
    home.file."${config.xdg.configHome}/nvim/after/ftplugin/yacc.vim".text = twoSpaceIndentConfig;
    home.file."${config.xdg.configHome}/nvim/after/ftplugin/lex.vim".text = twoSpaceIndentConfig;
    home.file."${config.xdg.configHome}/nvim/after/ftplugin/cpp.vim".text = twoSpaceIndentConfig;
    home.file."${config.xdg.configHome}/nvim/after/ftplugin/tex.vim".text = twoSpaceIndentConfig;

    home.file."${config.xdg.configHome}/nvim/lua/generic_lsp.lua".source = ./generic_lsp.lua;

    home.sessionVariables = {
      EDITOR = "nvim";
      MANPAGER = "nvim +Man!";
    };
  };
}
