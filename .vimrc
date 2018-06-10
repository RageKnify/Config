syntax on

" let g:powerline_pycmd="py3"

let g:airline_powerline_fonts = 1

set laststatus=2

let g:bufferline_echo = 0

set nowrap

set so=5

set number

set relativenumber

set numberwidth=3

set expandtab

set shiftwidth=4

set softtabstop=4

set colorcolumn=81,82,83

match ErrorMsg '\%>80v.\+'

set columns=87

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

call plug#end()

hi! Normal ctermbg=NONE guibg=NONE
