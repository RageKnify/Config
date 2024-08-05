{ pkgs, profiles, ... }:
{
  imports = with profiles.home; [
    ./profiles/home/fish.nix
    ./profiles/home/neovim
    ./profiles/home/tmux.nix
    ./profiles/home/kitty.nix
    ./profiles/home/gtk.nix
    ./profiles/home/sxhkd.nix
    ./modules/home/git/default.nix
    # ./modules/home/graphical/i3.nix
    # ./modules/home/graphical/polybar.nix
    # ./modules/home/personal.nix
  ];

  modules = {
    # graphical = {
    #   i3.enable = true;
    #   polybar = { enable = true; };
    # };
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
      "stash.cfdata.org bitbucket.cfdata.org stash.cfops.it" = {
        hostname = "git.cfdata.org";
        proxyCommand = "/usr/local/bin/cloudflared access ssh --hostname %h";
        setEnv.TERM = "xterm-256color";
      };
      "*.ssh.cfdata.org" = {
        proxyCommand = "/usr/local/bin/cloudflared access ssh --hostname %h";
        setEnv.TERM = "xterm-256color";
      };
      "131*" = {
        proxyJump = "sfo06.ssh.cfdata.org";
      };
      "133*" = {
        proxyJump = "sfo07.ssh.cfdata.org";
      };
      "36*" = {
        proxyJump = "pdx01.ssh.cfdata.org";
      };
      "99*" = {
        proxyJump = "lux01.ssh.cfdata.org";
      };
    };
  };

  programs.home-manager.enable = true;

  programs = {
    htop.enable = true;
    fzf = {
      enable = true;
      enableFishIntegration = true;
    };
  };

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
