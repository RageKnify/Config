# hosts/war/configuration.nix

{ config, pkgs, options, inputs, lib, configDir, ... }:
{
  services.xserver = {
    enable = true;
    layout = "pt";
    lipinput = {
      enable = true;
      touchpad.naturalScrolling = true;
    };
    displayManager = {
      sddm.enable = true;
      setupCommands = "";
    };
    windowManager.i3 = {
      enable = true;
      configFile = "$HOME/.config/i3/config";
    };
  };

  boot.cleanTmpDir = true;

  zramSwap.enable = true;

  sound.enable = true;

  users = {
    mutableUsers = true;
    users.jp = {
      isNormalUser = true;
      createHome = true;
      shell = pkgs.fish;
      extraGroups = [ "wheel" ];
    };
  };

  fonts.fonts = with pkgs; [
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
  ];

  environment.systemPackages = with pkgs; [
    firefox
    alacritty
    neovim
  ];

  networking.networkmanager.enable = true;
  programs.nm-applet.enable = true;

  services.fwupd.enable = true;

  hardware.cpu.intel.updateMicrocode = true;
  hardware.enableRedistributableFirmware = true;
}
