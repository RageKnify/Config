{ pkgs, ... }: {
  modules = {
    neovim.enable = true;
    xdg.enable = true;
    personal.enable = true;
    shell.git.enable = true;
    shell.tmux.enable = true;
  };

  # to enable starhip in nix-shells
  programs.bash.enable = true;

  home.stateVersion = "21.11";
}
