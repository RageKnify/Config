syntax on

filetype plugin indent on

set path+=**

let g:bufferline_echo = 0

set nowrap

set scrolloff=5

set splitbelow
set splitright

set shiftwidth=4
set softtabstop=4
set tabstop=4

autocmd Filetype html setlocal ts=2 sts=2 sw=2 expandtab
autocmd BufNewFile *.html 0r ~/.config/nvim/templates/html.skel

let g:c_syntax_for_h=1

let javaScript_fold=1

set foldmethod=syntax

" Fancy fold markers
function! MyFoldText()
    let line = getline(v:foldstart)
    let foldedlinecount = v:foldend - v:foldstart + 1
    return '  '. foldedlinecount . line
endfunction
set foldtext=MyFoldText()
set fillchars=fold:·

autocmd! vimenter * call SetupEnv()

function! SetupEnv()
	let l:proj_vim = './.proj.vim'
	if filereadable(l:proj_vim)
		echo "Sourcing " .l:proj_vim
		exec "source " . l:proj_vim
	endif
endfunction

" Saves cursor position to be used next time the file is edited
autocmd BufReadPost *
    \ if line("'\"") > 1 && line("'\"") <= line("$") |
    \   execute "normal! g`\"" |
    \ endif

" makes n=Next and N=Previous for find (? / /)
nnoremap <expr> n  'Nn'[v:searchforward]
nnoremap <expr> N  'nN'[v:searchforward]

" Easy binds to leave insert mode
inoremap kj <Esc>
inoremap jk <Esc>

" Easy bind to leave terminal mode
tnoremap <Esc> <C-\><C-n>

" Change leader key to space bar
let mapleader = " "

" uses insensitive search unless a Capital letter is used
set ignorecase
set smartcase

"Highlight merge markers
match ErrorMsg '^\(<\|=\|>\)\{7\}\([^=].\+\)\?$'

set autoread

" Keeps undo history over different sessions
set undofile
set undodir=/tmp//

if empty(glob('~/.config/nvim/autoload/plug.vim'))
  silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

set signcolumn=yes

set hidden

set completeopt=noinsert,menuone,noselect

nnoremap <silent> <Up>       :resize +2<CR>
nnoremap <silent> <Down>     :resize -2<CR>
nnoremap <silent> <Left>     :vertical resize +2<CR>
nnoremap <silent> <Right>    :vertical resize -2<CR>

" Filter command
command! -nargs=? Filter let @a='' | execute 'g/<args>/y A' | new | setlocal bt=nofile | put! a

set spelllang=pt

set wildignore=*.o,*.pyc,*.class

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

call plug#begin('~/.config/nvim/plugged')

Plug 'kyazdani42/nvim-web-devicons'
Plug 'nvim-lualine/lualine.nvim'
set laststatus=2
set showtabline=2
set noshowmode

" git wrapper
Plug 'tpope/vim-fugitive'

" Auto match pairs: () [] {} '' ""
Plug 'Raimondi/delimitMate'
let delimitMate_expand_cr=2
let delimitMate_expand_space=1

" Highlights other uses of the word currently under the cursor
Plug 'RRethy/vim-illuminate'
let g:Illuminate_delay = 100
hi def link LspReferenceText CursorLine
hi def link LspReferenceRead CursorLine
hi def link LspReferenceWrite CursorLine

" completion
Plug 'ms-jpq/coq_nvim', {'branch': 'coq'}
" don't close on keystroke, wait for new results to replace
let g:coq_settings = { 'display.pum.fast_close': v:false }
" 9000+ snippets
Plug 'ms-jpq/coq.artifacts', {'branch': 'artifacts'}

" neovim's LSP implementation configs
Plug 'neovim/nvim-lspconfig'

Plug 'nvim-lua/lsp_extensions.nvim', {'for': 'rust'}

" neovim's treesitter
Plug 'nvim-treesitter/nvim-treesitter', { 'do': ':TSUpdate' }
Plug 'nvim-treesitter/nvim-treesitter-textobjects'

" Asynchronous Lint Engine
let g:ale_set_signs = 0
au VimEnter,BufEnter,ColorScheme *
	\ exec "hi! ALEInfoLine
	\ guifg=".(&background=='light'?'#002b36':'#ffff00')."
	\ guibg=".(&background=='light'?'#859900':'#555500') |
	\ exec "hi! ALEWarningLine
	\ guifg=".(&background=='light'?'#002b36':'#ffff00')."
	\ guibg=".(&background=='light'?'#b58900':'#555500') |
	\ exec "hi! ALEErrorLine
	\ guifg=".(&background=='light'?'#002b36':'#ff0000')."
	\ guibg=".(&background=='light'?'#dc322f':'#550000')
Plug 'dense-analysis/ale'
let g:ale_linters = {
\	'rust': [],
\}
let g:ale_fixers = {
\	'*': ['trim_whitespace'],
\	'rust': [
\		'rustfmt',
\	],
\	'java': [
\		'google_java_format',
\		'trim_whitespace',
\	],
\}
let g:ale_fix_on_save = 1
let g:ale_fix_on_save_ignore = {'gitcommit': ['trim_whitespace']}

" Generates LaTeX PDF
Plug 'ying17zi/vim-live-latex-preview', {'for': 'tex'}
let g:livepreview_previewer = 'zathura'
let g:livepreview_cursorhold_recompile = 0

" Julia goodies
Plug 'JuliaEditorSupport/julia-vim'

" Coq goodies
Plug 'whonore/Coqtail'

" Ansible goodies
Plug 'pearofducks/ansible-vim'
let g:ansible_unindent_after_newline = 1

" Shows marks at left
Plug 'kshenoy/vim-signature'

" Fuzzy find things
source /usr/share/vim/vimfiles/plugin/fzf.vim
Plug 'junegunn/fzf.vim'
" Reverse the layout to make the FZF list top-down
let $FZF_DEFAULT_OPTS='--layout=reverse'

" Using the custom window creation function
let g:fzf_layout = { 'window': { 'height': 0.75, 'width': 0.75 } }

" Avoiding W
cabbrev W w

" fuzzy find files in the working directory (where you launched Vim from)
nmap <expr> <leader>f fugitive#head() != '' ? ':GFiles --cached --others --exclude-standard<CR>' : ':Files<CR>'
" fuzzy find lines in the current file
nmap <leader>/ :BLines<cr>
" fuzzy find an open buffer
nmap <leader>b :Buffers<cr>
" fuzzy find text in the working directory
nmap <leader>rg :Rg<cr>
" fuzzy find Vim commands (like Ctrl-Shift-P in Sublime/Atom/VSC)
nmap <leader>c :Commands<cr>

Plug 'ojroques/nvim-lspfuzzy'

" gc<operator> to toggle comment respective lines
Plug 'tpope/vim-commentary'

Plug 'andweeb/presence.nvim'

let g:presence_auto_update       = 1
let g:presence_editing_text      = "Editing %s"
let g:presence_workspace_text    = "Working on %s"
let g:presence_neovim_image_text = "vim but better"
let g:presence_main_image        = "neovim"

Plug 'RRethy/nvim-base16'

Plug 'nvim-lua/plenary.nvim'
Plug 'lewis6991/gitsigns.nvim'

Plug 'luukvbaal/stabilize.nvim'

call plug#end()

lua require('stabilize').setup()

lua require('gitsigns').setup()

" colorscheme settings
set background=light
colorscheme base16-solarized-light
lua require'nvim-treesitter.configs'.setup { highlight = { enable = true } }

" nvim-lsp setup
lua << EOF
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities.textDocument.completion.completionItem.resolveSupport = {
	properties = {
		'documentation',
		'detail',
		'additionalTextEdits',
	}
}

require'lspconfig'.rust_analyzer.setup{
	capabilities = capabilities,
	on_attach = require'generic_lsp'
}
function file_exists(name)
   local f=io.open(name,"r")
   if f~=nil then io.close(f) return true else return false end
end
if file_exists('pyls') then
	require'lspconfig'.pyls.setup{
		capabilities = capabilities,
		on_attach = require'generic_lsp'
	}
end
require'lspconfig'.julials.setup{
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

lua << EOF
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
	vim.lsp.diagnostic.on_publish_diagnostics, {
		underline = false,

		virtual_text = {
			spacing = 1,
			prefix = ' ',
		},

		signs = true,

		-- This is similar to:
		-- "let g:diagnostic_insert_delay = 1"
		update_in_insert = false,
	}
)
EOF

call sign_define("DiagnosticsSignError", {"text" : "", "texthl" : "DiagnosticsSignError"})
call sign_define("DiagnosticsSignWarn", {"text" : "", "texthl" : "DiagnosticsSignWarn"})
call sign_define("DiagnosticsSignInfo", {"text" : "", "texthl" : "DiagnosticsSignInfo"})
call sign_define("DiagnosticsSignHint", {"text" : "", "texthl" : "DiagnosticsSignHint"})

lua require('lspfuzzy').setup {}

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
				sources = {nvim_lsp, ale},
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

lua <<EOF
require'nvim-treesitter.configs'.setup {
  textobjects = {
    select = {
      enable = true,

      -- Automatically jump forward to textobj, similar to targets.vim
      lookahead = true,

      keymaps = {
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",
        ["ac"] = "@class.outer",
        ["ic"] = "@class.inner",
      },
    },
  },
}
EOF
