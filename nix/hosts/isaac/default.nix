# hosts/lazarus/system.nix
#
# Author: João Borges <RageKnify@gmail.com>
# URL:    https://github.com/RageKnify/Config
#
# System configuration.

{ pkgs, lib, config, hostSecretsDir, profiles, ... }: {
  imports = with profiles; [
    common
    docker
    server.full
    acme.common
    # TODO: maybe? acme.dns-jborges-eu
    # nextcloud
    # nginx.common
    rickbot
    vpn.tailscale
    zfs.common
    # zfs.email
    ./hardware.nix
  ];

  modules = {
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
    imports = with profiles.home; [ fish neovim tmux ];

    modules = { git.enable = true; };

    home.stateVersion = "23.05";
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

  system.stateVersion = "23.05";
}
