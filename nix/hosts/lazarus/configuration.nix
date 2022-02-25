{ pkgs, ... }: {
  imports = [
    ./hardware-configuration.nix


  ];

  boot.cleanTmpDir = true;
  zramSwap.enable = true;
  networking.hostName = "lazarus";
  networking.domain = "jplborges.pt";
  services.openssh.enable = true;
  nix = {
    package = pkgs.nixFlakes;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  nix.trustedUsers = [ "root" "@wheel" ];
  users = {
    mutableUsers = true;
    users = {
      root.openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIC2sdJFvvnEIYztPcznXvKpY4vOWedZ1qzDaAgRxrczS jp@war"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAII9ckbhT0em/dL75+RV+sdqwbprRC9Ff/MoqqpBgbUSh jp@pestilence"
      ];
      jp = {
        isNormalUser = true;
        createHome = true;
        shell = pkgs.fish;
        extraGroups = [ "wheel" ];
        openssh.authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIC2sdJFvvnEIYztPcznXvKpY4vOWedZ1qzDaAgRxrczS jp@war"
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAII9ckbhT0em/dL75+RV+sdqwbprRC9Ff/MoqqpBgbUSh jp@pestilence"
        ];
      };
    };
  };
}
