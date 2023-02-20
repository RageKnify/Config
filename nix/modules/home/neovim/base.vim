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

" Keeps undo history over different sessions
set undofile
set undodir=/tmp//

set signcolumn=yes

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
nnoremap <silent> <leader>m :silent call jobstart('make')<cr>

set selection=exclusive

set mouse=a

au TextYankPost * lua vim.highlight.on_yank {higroup="IncSearch", timeout=1000, on_visual=true}

let g:bufferline_echo = 0

set nowrap

set scrolloff=5

set splitbelow
set splitright

" Avoiding W
cabbrev W w

" Fancy fold markers
function! MyFoldText()
    let line = getline(v:foldstart)
    let foldedlinecount = v:foldend - v:foldstart + 1
    return '  '. foldedlinecount . ' ' . line
endfunction
set foldtext=MyFoldText()
