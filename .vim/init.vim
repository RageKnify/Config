syntax on

" let g:powerline_pycmd="py3"

let g:airline_powerline_fonts = 1

let g:airline_theme='base16'

set laststatus=2

let g:bufferline_echo = 0

let g:ycm_global_ycm_extra_conf = '~/.vim/.ycm_extra_conf.py'

let g:ycm_server_python_interpreter = '/bin/python2'

set nowrap

set so=5

set number

set relativenumber

set numberwidth=3

set expandtab

set shiftwidth=4

set softtabstop=4

autocmd BufReadPost *
    \ if line("'\"") > 1 && line("'\"") <= line("$") |
    \   execute "normal! g`\"" |
    \ endif

nnoremap <expr> n  'Nn'[v:searchforward]
nnoremap <expr> N  'nN'[v:searchforward]

inoremap jj <Esc>
inoremap kj <Esc>
inoremap jk <Esc>
inoremap kk <Esc>

set colorcolumn=81,82,83

match ErrorMsg '\%>80v.\+'

"set columns=87

if filereadable(expand("~/.vimrc_background"))
  let base16colorspace=256
  "source ~/.vimrc_background
endif

source ~/.config/nvim/colorscheme.vim

if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')

Plug 'scrooloose/nerdtree'

Plug 'vim-airline/vim-airline'

Plug 'vim-airline/vim-airline-themes'

Plug 'tpope/vim-fugitive'

Plug 'Raimondi/delimitMate'

call plug#end()

hi! Normal ctermbg=NONE guibg=NONE
