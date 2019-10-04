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
autocmd BufNewFile *.html 0r ~/.config/nvim/templates/html.skel

autocmd BufRead,BufNewFile *.h set filetype=c

let javaScript_fold=1

set foldmethod=syntax

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

" Limit myself to 80 characters
set colorcolumn=81,82
"Highlight merge markers
match ErrorMsg '^\(<\|=\|>\)\{7\}\([^=].\+\)\?$'

set autoread

" Keeps undo history over different sessions
set undofile
set undodir=~/.cache/nvim/undodir

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

set selection=exclusive

set mouse=a

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
let g:crystalline_theme = 'gruvbox'

set showtabline=2
set laststatus=2
set noshowmode
Plug 'rbong/vim-crystalline'


Plug 'tpope/vim-fugitive'

Plug 'Raimondi/delimitMate'
let delimitMate_expand_cr=2
let delimitMate_expand_space=1

Plug 'RRethy/vim-illuminate'
let g:Illuminate_delay = 100

Plug 'dense-analysis/ale'
let g:ale_completion_enabled = 1
let g:ale_fixers = {
\	'*': ['trim_whitespace'],
\	'java': [
\		'google_java_format',
\	],
\}
let g:ale_fix_on_save = 1

Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
let g:deoplete#enable_at_startup = 1

Plug 'Shougo/deoplete-clangx'

Plug 'ying17zi/vim-live-latex-preview'

Plug 'thiagoalessio/rainbow_levels.vim'
hi! RainbowLevel0 ctermbg=240 guibg=#fdf6e3
hi! RainbowLevel1 ctermbg=239 guibg=#f5eedb
hi! RainbowLevel2 ctermbg=238 guibg=#ede6d3
hi! RainbowLevel3 ctermbg=237 guibg=#e5decb
hi! RainbowLevel4 ctermbg=236 guibg=#ddd6cb
hi! RainbowLevel5 ctermbg=235 guibg=#d5cebb
hi! RainbowLevel6 ctermbg=234 guibg=#cdc6b3
hi! RainbowLevel7 ctermbg=233 guibg=#c5beab
hi! RainbowLevel8 ctermbg=232 guibg=#bdb6a3

Plug 'RRethy/vim-hexokinase'
let g:Hexokinase_virtualText = '■■■'
let g:Hexokinase_refreshEvents = ['BufWritePost']
let g:Hexokinase_ftAutoload = ['css', 'xml', 'vim']

Plug 'kkoomen/vim-doge'

Plug 'kshenoy/vim-signature'

Plug '/usr/local/opt/fzf'
Plug 'junegunn/fzf.vim'
" Reverse the layout to make the FZF list top-down
let $FZF_DEFAULT_OPTS='--layout=reverse'

" Using the custom window creation function
let g:fzf_layout = { 'window': 'call FloatingFZF()' }

" Function to create the custom floating window
function! FloatingFZF()
  " creates a scratch, unlisted, new, empty, unnamed buffer
  " to be used in the floating window
  let buf = nvim_create_buf(v:false, v:true)

  " height -> 15 lines
  let height = 15 " float2nr(&lines * 0.5)
  " 50% of the width
  let width = float2nr(&columns * 0.5)
  " horizontal position (centralized)
  let horizontal = float2nr((&columns - width) / 2)
  " vertical position (centralized)
  let vertical = float2nr((&lines - height) / 2)

  let opts = {
        \ 'relative': 'editor',
        \ 'row': vertical,
        \ 'col': horizontal,
        \ 'width': width,
        \ 'height': height
        \ }

  " open the new window, floating, and enter to it
  call nvim_open_win(buf, v:true, opts)
endfunction

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

Plug 'tpope/vim-commentary'

Plug 'lifepillar/vim-solarized8'

call plug#end()

" colorscheme settings
set background=light
set termguicolors
colorscheme solarized8_high
let g:solarized_old_cursor_style=1

" hi! Normal ctermbg=NONE guibg=NONE
