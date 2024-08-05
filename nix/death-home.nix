{ pkgs, profiles, ... }:
{
  imports = with profiles.home; [
    fish
    gtk
    kitty
    neovim
    niri
    rofi
    tmux
    waybar
  ];

  modules = {
    git = {
      enable = true;
    };
  };

  home.packages = with pkgs; [
    typescript-language-server
  ];

  programs.ssh = {
    enable = true;
    extraConfig = ''
      IdentityFile ~/.ssh/id_ed25519
      AddKeysToAgent yes
      ControlMaster=auto
      ControlPath=/tmp/%r@%h:%p
      ControlPersist=3600
    '';
    matchBlocks =
      let
        extraOptions = {
          IdentityAgent = "\${XDG_RUNTIME_DIR}/yubikey-agent/yubikey-agent-cloudflare.sock";
        };
          proxyCommand = "/usr/local/bin/cloudflared access ssh --hostname %h";
      in
      {
        "*.ssh.cfdata.org" = {
          inherit extraOptions proxyCommand;
          setEnv.TERM = "xterm-256color";
        };
        "*.in.cfops.net" = {
          inherit extraOptions proxyCommand;
        };
        "*.ssh" = {
          inherit extraOptions proxyCommand;
        };
        "macmini10" = {
          user = "prtester";
          hostname = "172.71.91.10";
          proxyJump = "251dm1.ssh.cfdata.org";
          inherit extraOptions;
        };
        "macmini11" = {
          user = "prtester";
          hostname = "172.71.91.11";
          proxyJump = "251dm1.ssh.cfdata.org";
          inherit extraOptions;
        };
        "macmini12" = {
          user = "prtester";
          hostname = "172.71.91.12";
          proxyJump = "251dm1.ssh.cfdata.org";
          inherit extraOptions;
        };
        "macmini13" = {
          user = "prtester";
          hostname = "172.71.91.13";
          proxyJump = "251dm1.ssh.cfdata.org";
          inherit extraOptions;
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
      "$HOME/.local/bin"
      "$HOME/.cargo/bin"
    ];
    keyboard = null;
    username = "jborges";
    homeDirectory = "/home/jborges";
    stateVersion = "23.11";
  };
}
