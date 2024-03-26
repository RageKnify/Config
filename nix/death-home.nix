{ pkgs, profiles, ... }: 
{
  imports = with profiles.home; [
    fish
    neovim
    tmux
    kitty
    gtk
    sxhkd
  ];
  modules = {
    xdg.enable = true;
    graphical = {
      i3.enable = true;
      polybar = { enable = true; };
    };
    git = {
      enable = true;
    };
  };

  programs.ssh = {
    enable = true;
    extraConfig = ''
      IdentityFile ~/.ssh/id_ed25519
      AddKeysToAgent yes
    '';
    matchBlocks = {
      "bitbucket.cfdata.org stash.cfops.it" = {
        hostname = "git.cfdata.org";
        proxyCommand = "/usr/local/bin/cloudflared access ssh --hostname %h";
        setEnv.TERM = "xterm-256color";
      };
    };
  };
  
  programs.home-manager.enable = true;

  home = {
    sessionPath = [
      "$HOME/.cargo/bin"
    ];
    keyboard = null;
    username = "jborges";
    homeDirectory = "/home/jborges";
    stateVersion = "23.11";
  };

}
