# hosts/conquest/default.nix
#
# Author: João Borges <RageKnify@gmail.com>
# URL:    https://github.com/RageKnify/Config
#
# system configuration.

{ pkgs, lib, config, hostSecretsDir, profiles, ... }: {
  imports = with profiles; [
    common
    graphical.full
    docker
    server.full
    acme.common
    # TODO: maybe? acme.dns-jborges-eu
    nextcloud
    nginx.common
    # rickbot # docker image doesn't work
    vpn.tailscale
    zfs.common
    zfs.email
    ./hardware.nix
  ];

  services.xserver.videoDrivers = [ "nvidia" ];

  modules = {
    personal.enable = true;
    services.backups = {
      enable = true;

      passwordFile = config.age.secrets.resticPassword.path;

      environmentFile = config.age.secrets.backupEnvFile.path;
    };
    physical.enable = true;
  };

  age.secrets = {
    resticPassword.file = "${hostSecretsDir}/resticPassword.age";
    backupEnvFile.file = "${hostSecretsDir}/backupEnvFile.age";
  };

  users = {
    users.root = {
      hashedPassword =
        "$6$97MgEve.PfCq/8gb$kX0aZAQyFbmye7mhw8YlMwKwnyft543GRD.O1mOnJIGsdn6/FXcVIleslO/2lrOhs8LEX/Nwlhz46vYn.zDDt0";
    };
    mutableUsers = false;
  };

  home-manager.users.jp = {
    imports = with profiles.home; [
      fish
      neovim
      tmux
      kitty
      gtk
      ssh
      sxhkd
      fusuma
    ];

    modules = {
      xdg.enable = true;
      graphical = {
        i3.enable = true;
        polybar = { enable = true; };
      };
      git = {
        enable = true;
        includes = [
          {
            condition = "gitdir:~/dev/github/";
            contents.user = {
              name = "RageKnify";
              email = "RageKnify@gmail.com";
            };
          }
          {
            condition = "gitdir:~/dev/gitlab.rnl/";
            contents.user = {
              name = "João Borges";
              email = "joao.p.l.borges@tecnico.ulisboa.pt";
            };
          }
          {
            condition = "gitdir:~/dev/ark/";
            contents.user = {
              name = "João Borges";
              email = "joao.borges@rnl.tecnico.ulisboa.pt";
            };
          }
        ];
      };
    };

    home.stateVersion = "23.11";
  };

  networking = {
    useDHCP = true;

    nameservers =
      [ "1.1.1.1" "1.0.0.1" "2606:4700:4700::1111" "2606:4700:4700::1001" ];
  };

  services.openssh = {
    hostKeys = [{
      path = "/persist/etc/ssh/ssh_host_ed25519_key";
      type = "ed25519";
    }];
  };

  system.stateVersion = "23.11";
}
