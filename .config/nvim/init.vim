syntax on

filetype plugin indent on

set path+=**

let g:bufferline_echo = 0

set nowrap

set so=5

set splitbelow
set splitright

set shiftwidth=4
set softtabstop=4
set tabstop=4

autocmd Filetype html setlocal ts=2 sts=2 sw=2 expandtab

set fdm=syntax

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


let base16colorspace=256
set termguicolors
set background=light

source ~/.config/nvim/colorscheme.vim

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

call plug#begin('~/.vim/plugged')

function! StatusLine(current)
  return (a:current ? crystalline#mode() . '%#Crystalline#' : '%#CrystallineInactive#')
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
let g:crystalline_theme = 'solarized'

set showtabline=2
set laststatus=2
set noshowmode
Plug 'rbong/vim-crystalline'


Plug 'tpope/vim-fugitive'

Plug 'Raimondi/delimitMate'

Plug 'RRethy/vim-illuminate'
let g:Illuminate_delay = 100

Plug 'w0rp/ale'
let g:ale_completion_enabled = 1
let g:ale_fixers = {
\	'java': [
\		'google_java_format',
\	],
\}
let g:ale_linters = {
\	'cpp': ['ccls', 'clangcheck', 'clangd', 'clang', 'clazy', 'cppcheck',
\	'cpplint', 'cquery', 'flawfinder', 'gcc']
\}

Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
let g:deoplete#enable_at_startup = 1

Plug 'Shougo/neoinclude.vim'

Plug 'Shougo/deoplete-clangx'

Plug 'SirVer/ultisnips'

Plug 'honza/vim-snippets'

Plug 'roxma/nvim-yarp'

Plug 'ying17zi/vim-live-latex-preview'

Plug 'RRethy/vim-hexokinase'
let g:Hexokinase_virtualText = '■■■'
let g:Hexokinase_refreshEvents = ['BufWritePost']
let g:Hexokinase_ftAutoload = ['css', 'xml']

Plug '/usr/local/opt/fzf'
Plug 'junegunn/fzf.vim'
" fuzzy find files in the working directory (where you launched Vim from)
nmap <leader>f :Files<cr>
" fuzzy find lines in the current file
nmap <leader>/ :BLines<cr>
" fuzzy find an open buffer
nmap <leader>b :Buffers<cr>
" fuzzy find text in the working directory
nmap <leader>r :Rg<cr>
" fuzzy find Vim commands (like Ctrl-Shift-P in Sublime/Atom/VSC)
nmap <leader>c :Commands<cr>

call plug#end()

hi! Normal ctermbg=NONE guibg=NONE
