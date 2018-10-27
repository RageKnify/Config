syntax on

filetype plugin indent on

set laststatus=2

let g:bufferline_echo = 0

set nowrap

set so=5

"set number
"set relativenumber
"set numberwidth=3

set splitbelow
set splitright

set shiftwidth=4

set softtabstop=4

set tabstop=4

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

" Limit myself to 80 characters
set colorcolumn=81,82,83
"match ErrorMsg '\%>80v.\+'

let base16colorspace=256

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


call plug#begin('~/.vim/plugged')

" Changes the working directory to the project root
Plug 'airblade/vim-rooter'
let g:rooter_patterns = ['Rakefile', '.git/', 'CVS']

Plug 'scrooloose/nerdtree'
let g:NERDTreeWinSize=25

Plug 'vim-airline/vim-airline'

Plug 'vim-airline/vim-airline-themes'
let g:airline_powerline_fonts = 1
let g:airline_theme='base16'
let g:airline#extensions#ale#enabled = 1

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

call plug#end()

hi! Normal ctermbg=NONE guibg=NONE
