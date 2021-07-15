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

nnoremap <Up>       :resize +2<CR>
nnoremap <Down>     :resize -2<CR>
nnoremap <Left>     :vertical resize +2<CR>
nnoremap <Right>    :vertical resize -2<CR>

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

" Shows the effects of a command incrementally, as you type.
set inccommand=nosplit

call plug#begin('~/.config/nvim/plugged')

Plug 'hoob3rt/lualine.nvim'
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

" neovim completion
Plug 'hrsh7th/nvim-compe'
set completeopt=menuone,noselect
let g:compe = {}
let g:compe.enabled = v:true
let g:compe.autocomplete = v:true
let g:compe.debug = v:false
let g:compe.min_length = 1
let g:compe.preselect = 'enable'
let g:compe.throttle_time = 80
let g:compe.source_timeout = 200
let g:compe.incomplete_delay = 400
let g:compe.max_abbr_width = 100
let g:compe.max_kind_width = 100
let g:compe.max_menu_width = 100
let g:compe.documentation = v:true

let g:compe.source = {}
let g:compe.source.path = v:true
let g:compe.source.buffer = v:true
let g:compe.source.calc = v:true
let g:compe.source.vsnip = v:true
let g:compe.source.nvim_lsp = v:true
let g:compe.source.nvim_lua = v:true
let g:compe.source.spell = v:true
let g:compe.source.tags = v:true
let g:compe.source.snippets_nvim = v:true
let g:compe.source.treesitter = v:true
let g:compe.source.omni = v:true

" Snippets
Plug 'hrsh7th/vim-vsnip'

Plug 'hrsh7th/vim-vsnip-integ'

" neovim's LSP implementation configs
Plug 'neovim/nvim-lspconfig'

Plug 'nvim-lua/completion-nvim'

Plug 'nvim-lua/lsp_extensions.nvim', {'for': 'rust'}

" neovim's treesitter
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

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

call plug#end()

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
require'lspconfig'.pyls.setup{
	capabilities = capabilities,
	on_attach = require'generic_lsp'
}
require'lspconfig'.julials.setup{
	capabilities = capabilities,
	on_attach = require'generic_lsp'
}
EOF

nnoremap <silent> <leader>n <cmd>lua vim.lsp.diagnostic.goto_next { wrap = false }<CR>
nnoremap <silent> <leader>p <cmd>lua vim.lsp.diagnostic.goto_prev { wrap = false }<CR>
nnoremap <silent> <leader>d <cmd>lua vim.lsp.buf.definition()<CR>
nnoremap <silent> <leader>gr <cmd>lua vim.lsp.buf.references()<CR>
nnoremap <silent> <leader>rn <cmd>lua vim.lsp.buf.rename()<CR>
nnoremap <silent> <leader>a <cmd>lua vim.lsp.buf.code_action()<CR>
nnoremap <silent> <leader><cr> <cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<cr>

autocmd BufEnter * lua require'completion'.on_attach()
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

call sign_define("LspDiagnosticsSignError", {"text" : "", "texthl" : "LspDiagnosticsVirtualTextError"})
call sign_define("LspDiagnosticsSignWarning", {"text" : "", "texthl" : "LspDiagnosticsVirtualTextWarning"})
call sign_define("LspDiagnosticsSignInformation", {"text" : "", "texthl" : "LspDiagnosticsVirtualTextInformation"})
call sign_define("LspDiagnosticsSignHint", {"text" : "", "texthl" : "LspDiagnosticsVirtualTextHint"})

lua require('lspfuzzy').setup {}

lua << EOF
require('lualine').setup {
	options = {
		theme = 'auto',
		section_separators = {'', ''},
		component_separators = {'', ''},
		icons_enabled = true
	},
	sections = {
		lualine_b = { 'diff' },
		lualine_c = {
			{'diagnostics', {
				sources = {nvim_lsp, ale},
				symbols = {error = ':', warn =':', info = ':', hint = ':'}}},
			{'filename', {file_status = true}}
		},
		lualine_x = { 'encoding', 'filetype' },
	},
	tabline = {
		lualine_a = { 'hostname' },
		lualine_b = { 'branch' },
		lualine_c = { {'filename', {file_status = true, shorten = false, full_path = true}}}
	},
	extensions = { fzf, fugitive },
}
EOF
