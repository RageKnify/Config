syntax on

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

let g:NERDTreeWinSize=25

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

let g:airline_powerline_fonts = 1

let g:airline_theme='base16'

let g:airline#extensions#ale#enabled = 1

let g:ale_completion_enabled = 1

set signcolumn=yes

set hidden

let g:LanguageClient_serverCommands = {
    \ 'rust': ['rustup', 'run', 'nightly', 'rls'],
    \ 'javascript': ['javascript-typescript-stdio'],
    \ 'python': ['pyls'],
    \ }

nnoremap <silent> K :call LanguageClient#textDocument_hover()<CR>
nnoremap <silent> gd :call LanguageClient#textDocument_definition()<CR>
nnoremap <silent> <F2> :call LanguageClient#textDocument_rename()<CR>

" ncm2
autocmd bufEnter * call ncm2#enable_for_buffer()

set completeopt=noinsert,menuone,noselect

inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-n>" : "<S-Tab>"

call plug#begin('~/.vim/plugged')

Plug 'scrooloose/nerdtree'

Plug 'vim-airline/vim-airline'

Plug 'vim-airline/vim-airline-themes'

Plug 'tpope/vim-fugitive'

Plug 'Raimondi/delimitMate'

Plug 'w0rp/ale'

Plug 'roxma/nvim-yarp'

Plug 'ncm2/ncm2'

Plug 'autozimu/LanguageClient-neovim', {
    \ 'branch': 'next',
    \ 'do': 'bash install.sh',
    \ }

call plug#end()

hi! Normal ctermbg=NONE guibg=NONE
