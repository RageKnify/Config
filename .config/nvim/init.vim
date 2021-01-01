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

autocmd! vimenter * call SetupEnv()

function! SetupEnv()
	let l:proj_nvim = './.proj.nvim'
	if filereadable(l:proj_nvim)
		echo "Sourcing " .l:proj_nvim
		exec "source " . l:proj_nvim
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

" Limit myself to 80 characters
set colorcolumn=81,82
"Highlight merge markers
match ErrorMsg '^\(<\|=\|>\)\{7\}\([^=].\+\)\?$'

set autoread

" Keeps undo history over different sessions
set undofile
set undodir=/tmp//

" let base16colorspace=256

" source ~/.config/nvim/colorscheme.vim

if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
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

function! StatusLine(current)
  let l:errors = luaeval('vim.lsp.diagnostic.get_count(vim.fn.bufnr("%"), [[Error]])')
  let l:warnings = luaeval('vim.lsp.diagnostic.get_count(vim.fn.bufnr("%"), [[Warning]])')
  let l:pre = ''
  if l:errors
    let l:pre = l:pre . ' E' . l:errors
  endif
  if l:warnings
    let l:pre = l:pre . ' W' . l:warnings
  endif
  return (a:current ? crystalline#mode() . '%#Crystalline#' : '%#CrystallineInactive#')
        \ . ((l:errors + l:warnings) ? l:pre . ' |' : '')
        \ . ' %f%h%w%m%r '
        \ . (a:current ? '%#CrystallineFill# %{fugitive#head()} ' : '')
        \ . '%=' . (a:current ? '%#Crystalline# %{&paste?"PASTE ":""}%{&spell?"SPELL ":""}' . crystalline#mode_color() : '')
        \ . ' %{&ft}[%{&enc}][%{&ffs}] %l/%L %2(%v%) '
endfunction

function! TabLine()
  let l:vimlabel = has("nvim") ?  " NVIM " : " VIM "
  return crystalline#bufferline(2, len(l:vimlabel), 1) . '%=%#CrystallineTab# ' . l:vimlabel
endfunction

let g:crystalline_statusline_fn = 'StatusLine'
let g:crystalline_tabline_fn = 'TabLine'
let g:crystalline_theme = 'gruvbox'

set showtabline=2
set laststatus=2
set noshowmode
Plug 'rbong/vim-crystalline'

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

" neovim's LSP implementation configs
Plug 'neovim/nvim-lspconfig'

Plug 'nvim-lua/completion-nvim'

Plug 'nvim-lua/lsp_extensions.nvim', {'for': 'rust'}

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
\	],
\}
let g:ale_fix_on_save = 1
let g:ale_fix_on_save_ignore = {'gitcommit': ['trim_whitespace']}

" Generates LaTeX PDF
Plug 'ying17zi/vim-live-latex-preview', {'for': 'tex'}
let g:livepreview_previewer = 'zathura'
let g:livepreview_cursorhold_recompile = 0

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
nmap <leader>r :Rg<cr>
" fuzzy find Vim commands (like Ctrl-Shift-P in Sublime/Atom/VSC)
nmap <leader>c :Commands<cr>

Plug 'ojroques/nvim-lspfuzzy'

" gc<operator> to toggle comment respective lines
Plug 'tpope/vim-commentary'

Plug 'lifepillar/vim-solarized8'

call plug#end()

" colorscheme settings
set background=light
set termguicolors
colorscheme solarized8_high
let g:solarized_old_cursor_style=1

" hi! Normal ctermbg=NONE guibg=NONE

" nvim-lsp setup
lua require'lspconfig'.rust_analyzer.setup{ on_attach = require'generic_lsp' }
lua require'lspconfig'.pyls.setup{ on_attach = require'generic_lsp' }

nnoremap <silent> <leader>n <cmd>lua vim.lsp.diagnostic.goto_next { wrap = false }<CR>
nnoremap <silent> <leader>p <cmd>lua vim.lsp.diagnostic.goto_prev { wrap = false }<CR>
nnoremap <silent> <leader>d <cmd>lua vim.lsp.buf.definition()<CR>
nnoremap <silent> <leader>gr <cmd>lua vim.lsp.buf.references()<CR>
nnoremap <silent> <leader>a <cmd>lua vim.lsp.buf.code_action()<CR>
nnoremap <silent> <leader><cr> <cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<cr>

command LspDisable lua vim.lsp.stop_client(vim.lsp.get_active_clients())
command LspEnable edit

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
