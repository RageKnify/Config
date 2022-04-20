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
      extraConfig = ''
        " sane defaults
        set shiftwidth=4
        set softtabstop=4
        set tabstop=4
        set noexpandtab

        " delete trailing whitespace
        autocmd FileType c,cpp,java,lua,nix,ocaml,vim,wast autocmd BufWritePre <buffer> %s/\s\+$//e

        " makes n=Next and N=Previous for find (? / /)
        nnoremap <expr> n  'Nn'[v:searchforward]
        nnoremap <expr> N  'nN'[v:searchforward]

        " Easy bind to leave terminal mode
        tnoremap <Esc> <C-\><C-n>

        " Change leader key to space bar
        let mapleader = " "

        " fuzzy find files in the working directory (where you launched Vim from)
        nmap <expr> <leader>f fugitive#head() != "" ? ':GFiles --cached --others --exclude-standard<CR>' : ':Files<CR>'
        " fuzzy find lines in the current file
        nmap <leader>/ :BLines<cr>
        " fuzzy find an open buffer
        nmap <leader>b :Buffers<cr>
        " fuzzy find text in the working directory
        nmap <leader>rg :Rg<cr>
        " fuzzy find Vim commands (like Ctrl-Shift-P in Sublime/Atom/VSC)
        nmap <leader>c :Commands<cr>

        " Keeps undo history over different sessions
        set undofile
        set undodir=/tmp//

        " Saves cursor position to be used next time the file is edited
        autocmd BufReadPost *
        \ if line("'\"") > 1 && line("'\"") <= line("$") |
        \   execute "normal! g`\"" |
        \ endif

        nnoremap <silent> <Up>       :resize +2<CR>
        nnoremap <silent> <Down>     :resize -2<CR>
        nnoremap <silent> <Left>     :vertical resize +2<CR>
        nnoremap <silent> <Right>    :vertical resize -2<CR>

        "move to the split in the direction shown, or create a new split
        nnoremap <silent> <C-h> :call WinMove('h')<cr>
        nnoremap <silent> <C-j> :call WinMove('j')<cr>
        nnoremap <silent> <C-k> :call WinMove('k')<cr>
        nnoremap <silent> <C-l> :call WinMove('l')<cr>

        function! WinMove(key)
          let t:curwin = winnr()
          exec "wincmd ".a:key
          if (t:curwin == winnr())
            if (match(a:key,'[jk]'))
              wincmd v
            else
              wincmd s
            endif
            exec "wincmd ".a:key
          endif
        endfunction

        nnoremap <silent> <leader><leader> :nohlsearch<cr>

        set selection=exclusive

        set mouse=a

        au TextYankPost * lua vim.highlight.on_yank {higroup="IncSearch", timeout=1000, on_visual=true}

        let g:bufferline_echo = 0

        set nowrap

        set scrolloff=5

        set splitbelow
        set splitright

        set shiftwidth=4
        set softtabstop=4
        set tabstop=4

        " Avoiding W
        cabbrev W w
        '';
        plugins = with pkgs.unstable.vimPlugins; [
          nvim-web-devicons
          {
            plugin = lualine-nvim;
            config = ''
            set laststatus=2
            set showtabline=2
            set noshowmode
            lua << EOF
            require('lualine').setup {
                    options = {
                            theme = 'auto',
                            section_separators = {left='', right=''},
                            component_separators = {left='', right=''},
                            icons_enabled = true
                    },
                    sections = {
                            lualine_b = { 'diff' },
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
                            lualine_b = { 'branch' },
                            lualine_z = { {'tabs', tabs_color = { inactive = "TermCursor", active = "ColorColumn" } } }
                    },
                    extensions = { fzf, fugitive },
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
            EOF
            '';
          }

          vim-fugitive

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

          nvim-cmp
          cmp-treesitter
          cmp-nvim-lsp
          {
            plugin = (nvim-treesitter.withPlugins (plugins: with pkgs.unstable.tree-sitter-grammars; [
              tree-sitter-nix
              # TODO: rust and others only on dev machines
              tree-sitter-c
              tree-sitter-comment
              tree-sitter-lua
              tree-sitter-markdown
              tree-sitter-ocaml
              tree-sitter-rust
              tree-sitter-vim
            ]));
            config = "lua require'nvim-treesitter.configs'.setup { highlight = { enable = true } }";
          }

          {
            plugin = nvim-lspconfig;
            config = ''
lua << EOF
local lsp = require'lspconfig'

local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities.textDocument.completion.completionItem.resolveSupport = {
	properties = {
		'documentation',
		'detail',
		'additionalTextEdits',
	}
}

lsp.rust_analyzer.setup{
	capabilities = capabilities,
	on_attach = require'generic_lsp'
}
EOF
nnoremap <silent> <leader>n <cmd>lua vim.diagnostic.goto_next { wrap = false }<CR>
nnoremap <silent> <leader>p <cmd>lua vim.diagnostic.goto_prev { wrap = false }<CR>
nnoremap <silent> <leader>d <cmd>lua vim.lsp.buf.definition()<CR>
nnoremap <silent> <leader>gr <cmd>lua vim.lsp.buf.references()<CR>
nnoremap <silent> <leader>rn <cmd>lua vim.lsp.buf.rename()<CR>
nnoremap <silent> <leader>a <cmd>lua vim.lsp.buf.code_action()<CR>
nnoremap <silent> <leader><cr> <cmd>lua vim.diagnostic.open_float()<cr>
            '';
          }
          lsp_extensions-nvim

          vim-signature
          {
            plugin = fzf-vim;
            config = ''
            let $FZF_DEFAULT_OPTS='--layout=reverse'

            " Using the custom window creation function
            let g:fzf_layout = { 'window': { 'height': 0.75, 'width': 0.75 } }
            '';
          }

          vim-commentary

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

          {
            plugin = nvim-base16;
            config = ''
            " colorscheme settings
            set background=light
            colorscheme base16-solarized-light
            lua require'nvim-treesitter.configs'.setup { highlight = { enable = true } }
            '';
          }

          plenary-nvim
          {
            plugin = gitsigns-nvim;
            config = "lua require('gitsigns').setup()";
          }
        ];
    };

    # languages that should use 2 space indent
    home.file."${config.xdg.configHome}/nvim/after/ftplugin/markdown.vim".text = twoSpaceIndentConfig;
    home.file."${config.xdg.configHome}/nvim/after/ftplugin/nix.vim".text = twoSpaceIndentConfig;
    home.file."${config.xdg.configHome}/nvim/after/ftplugin/ocaml.vim".text = twoSpaceIndentConfig;
    home.file."${config.xdg.configHome}/nvim/after/ftplugin/wast.vim".text = twoSpaceIndentConfig;
    home.file."${config.xdg.configHome}/nvim/after/ftplugin/yaml.vim".text = twoSpaceIndentConfig;

    # Rust config
    home.file."${config.xdg.configHome}/nvim/after/ftplugin/rust.vim".text = ''
" Use LSP omni-completion in Rust files.
setlocal omnifunc=v:lua.vim.lsp.omnifunc
set foldexpr=nvim_treesitter#foldexpr()
set foldmethod=expr

lua << EOF
local inlay_hints = require('lsp_extensions').inlay_hints

-- Global function, so you can just call it on the lua side
ShowHintsLine = function()
  inlay_hints {
    only_current_line = true
  }
end

ShowHintsFile = function()
  inlay_hints()
end
EOF
" not working for some reason
" autocmd CursorHold,CursorHoldI *.rs :lua ShowHintsLine()

nnoremap <silent> <leader>h <cmd>lua ShowHintsFile()<CR>
    '';
    home.file."${config.xdg.configHome}/nvim/lua/generic_lsp.lua".text = ''
return function(client)
	-- [[ other on_attach code ]]
	vim.api.nvim_buf_set_keymap(0, 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', {noremap = true})

	-- illuminate stuff
	vim.api.nvim_buf_set_keymap(0, 'n', '<leader>gn', '<cmd>lua require"illuminate".next_reference{}<cr>', {noremap = true})
	vim.api.nvim_buf_set_keymap(0, 'n', '<leader>gp', '<cmd>lua require"illuminate".next_reference{reverse=true}<cr>', {noremap = true})
	require 'illuminate'.on_attach(client)
end
    '';

    home.sessionVariables = {
      EDITOR = "nvim";
      MANPAGER = "nvim +Man!";
    };
  };
}
