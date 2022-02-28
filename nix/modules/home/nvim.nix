# modules/home/nvim.nix
#
# Author: João Borges <RageKnify@gmail.com>
# URL:    https://github.com/RageKnify/Config
#
# nvim home configuration.

{ pkgs, ... }:
{
  programs.neovim.enable = true;
  programs.neovim.viAlias = true;
  programs.neovim.vimAlias = true;
  programs.neovim.vimdiffAlias = true;
  home.sessionVariables.EDITOR = "nvim";

  programs.neovim.configure = {
    customRC = ''
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

    set selection=exclusive
    '';
  };
}
