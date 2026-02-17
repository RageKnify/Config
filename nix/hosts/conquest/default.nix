# hosts/conquest/default.nix
#
# Author: João Borges <RageKnify@gmail.com>
# URL:    https://github.com/RageKnify/Config
#
# system configuration.

{
  pkgs,
  lib,
  config,
  hostSecretsDir,
  profiles,
  ...
}:
{
  imports = with profiles.nixos; [
    common
    graphical.full
    docker
    server.full
    acme.common
    acme.dns-jborges-eu
    nextcloud
    navidrome
    nginx.common
    # rickbot # docker image doesn't work
    vpn.tailscale
    zfs.common
    zfs.email
    ./hardware.nix
  ];

  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia = {

    # Modesetting is required.
    modesetting.enable = true;

    # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
    powerManagement.enable = false;
    # Fine-grained power management. Turns off GPU when not in use.
    # Experimental and only works on modern Nvidia GPUs (Turing or newer).
    powerManagement.finegrained = false;

    # Use the NVidia open source kernel module (not to be confused with the
    # independent third-party "nouveau" open source driver).
    # Support is limited to the Turing and later architectures. Full list of
    # supported GPUs is at:
    # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus
    # Only available from driver 515.43.04+
    # Currently alpha-quality/buggy, so false is currently the recommended setting.
    open = false;

    # Enable the Nvidia settings menu,
    # accessible via `nvidia-settings`.
    nvidiaSettings = true;

    # Optionally, you may need to select the appropriate driver version for your specific GPU.
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

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
      hashedPassword = "$6$97MgEve.PfCq/8gb$kX0aZAQyFbmye7mhw8YlMwKwnyft543GRD.O1mOnJIGsdn6/FXcVIleslO/2lrOhs8LEX/Nwlhz46vYn.zDDt0";
    };
    mutableUsers = false;
  };

  home-manager.users.jp = {
    imports = with profiles.home; [
      dunst
      fish
      neovim
      tmux
      kitty
      gtk
      ssh
      rofi
      sxhkd
      fusuma
    ];

    modules = {
      xdg.enable = true;
      graphical = {
        i3.enable = true;
        polybar = {
          enable = true;
        };
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
  };

  services.openssh = {
    hostKeys = [
      {
        path = "/persist/etc/ssh/ssh_host_ed25519_key";
        type = "ed25519";
      }
    ];
  };

  system.stateVersion = "23.11";
}
