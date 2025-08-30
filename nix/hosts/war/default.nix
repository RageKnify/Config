# hosts/war/system.nix
#
# Author: João Borges <RageKnify@gmail.com>
# URL:    https://github.com/RageKnify/Config
#
# System configuration.

{
  config,
  pkgs,
  lib,
  hostSecretsDir,
  profiles,
  ...
}:
{
  imports = with profiles.nixos; [
    common
    graphical.full
    vpn.tailscale
    zfs.common
    zfs.email
    ./hardware.nix
  ];

  modules = {
    laptop = {
      enable = true;
      battery = "BAT0";
      adapter = "ADP1";
      wlan_interface = "wlp2s0";
    };
    kanata = {
      enable = true;
      normal_device = "/dev/input/by-path/platform-i8042-serio-0-event-kbd";
    };
    syncthing = {
      enable = true;
      user = "jp";
    };
    services.backups = {
      enable = true;

      passwordFile = config.age.secrets.resticPassword.path;

      environmentFile = config.age.secrets.backupEnvFile.path;

      paths = [
        "/home/jp/documents"
        "/var/lib/libvirt"
      ];
    };
  };

  console.useXkbConfig = true;

  services.tlp = {
    enable = true;
    settings = {
      START_CHARGE_THRESH_BAT0 = 65;
      STOP_CHARGE_THRESH_BAT0 = 70;
    };
  };

  services.upower.enable = true;

  boot.loader = {
    # Use the systemd-boot EFI boot loader.
    systemd-boot = {
      enable = lib.mkForce false;
      editor = false;
      consoleMode = "auto";
      configurationLimit = 20;
    };
    timeout = 2;
    efi.canTouchEfiVariables = true;
  };

  boot.lanzaboote = {
    enable = true;
    pkiBundle = "/etc/secureboot/";
  };

  boot.supportedFilesystems = [ "zfs" ];
  boot.kernelParams = [ "nohibernate" ];
  boot.zfs.devNodes = "/dev";

  services.openssh = {
    hostKeys = [
      {
        path = "/etc/ssh/ssh_host_ed25519_key";
        type = "ed25519";
      }
    ];
  };

  age = {
    identityPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
    secrets = {
      wireguard-privkey = {
        file = "${hostSecretsDir}/wireguard-privkey.age";
        mode = "600";
        owner = "systemd-network";
        group = "systemd-network";
      };
      resticPassword.file = "${hostSecretsDir}/resticPassword.age";
      backupEnvFile.file = "${hostSecretsDir}/backupEnvFile.age";
    };
  };

  networking.hostId = "48a4b691";
  networking.networkmanager = {
    enable = true;
  };
  networking.firewall.checkReversePath = "loose";
  systemd.network =
    let
      rnlFwmark = 765;
      sttFwmark = 577;
    in
    {
      enable = true;
      config.routeTables.rnl = rnlFwmark;
      config.routeTables.stt = sttFwmark;
      netdevs."10-rnl" = {
        enable = true;
        netdevConfig = {
          Kind = "wireguard";
          MTUBytes = "1300";
          Name = "rnl";
        };
        wireguardConfig = {
          PrivateKeyFile = config.age.secrets.wireguard-privkey.path;
          FirewallMark = rnlFwmark;
          RouteTable = "rnl";
        };
        wireguardPeers = [
          {
            PublicKey = "g08PXxMmzC6HA+Jxd+hJU0zJdI6BaQJZMgUrv2FdLBY=";
            Endpoint = "193.136.164.211:34266";
            AllowedIPs = [
              # public RNL-operated ranges
              "193.136.164.0/24"
              "193.136.154.0/24"
              "2001:690:2100:80::/58"

              # public 3rd-party ranges
              "193.136.128.24/29" # DSI-RNL peering
              "146.193.33.81/32" # INESC watergate

              # private RNL-operated ranges
              "10.16.64.0/18"
              "192.168.154.0/24" # Labs AMT
              "192.168.20.0/24" # rnl VPN
              "fd92:3315:9e43:c490::/64" # rnl VPN

              # multicast
              "224.0.0.0/24"
              "ff02::/16"
              "239.255.255.250/32"
              "239.255.255.253/32"
              "fe80::/10"
            ];
            PersistentKeepalive = 25;
          }
        ];
      };
      networks."40-rnl" = {
        name = "rnl";

        addresses = [
          { Address = "192.168.20.13/24"; }
          { Address = "fd92:3315:9e43:c490::13/64"; }
        ];

        networkConfig = {
          LinkLocalAddressing = "no";
          IPv6AcceptRA = false;
          #MulticastDNS = true;
        };

        linkConfig = {
          Multicast = true;
          #AllMulticast = true;
        };

        routingPolicyRules = [
          {
            InvertRule = true;
            FirewallMark = rnlFwmark;
            Table = "rnl";
          }
        ];

        ntp = [ "ntp.rnl.tecnico.ulisboa.pt" ];

        dns = [
          "2001:690:2100:80::1"
          "193.136.164.2"
          "2001:690:2100:80::2"
          "193.136.164.1"
        ];
        domains =
          [
            # Main domain, with dns search
            "rnl.tecnico.ulisboa.pt"

            # alt domains
            "~rnl.ist.utl.pt"
            "~rnl.pt"

            # public ranges (DSI-assigned)
            "~164.136.193.in-addr.arpa"
            "~154.136.193.in-addr.arpa"
            "~8.0.0.0.0.1.2.0.9.6.0.1.0.0.2.ip6.arpa"

            # private ranges (rnl VPN)
            "~20.168.192.in-addr.arpa"
            "~0.9.4.c.3.4.e.9.5.1.3.3.2.9.d.f.ip6.arpa"

            # private range (Labs AMT)
            "~154.168.192.in-addr.arpa"
          ]
          ++ (
            # private ranges (DSI-assigned)
            builtins.map (octet: "~" + (builtins.toString octet) + ".16.10.in-addr.arpa") (lib.range 64 127)
          );

        extraConfig = ''
          [Network]
          DNSSEC=false
        '';
      };
    };

  users.users.root.hashedPassword = "$6$wlIVxKTns9xQ3Rc4$fbiA/wXnZ0l9TXKr90KmNVSltyU.MOH2Si8ntvLXINKGpug82rpFABP.PXAOp6Qtbq.onD8qAaSpq.TaKOmgj1";
  users.users.jp.extraGroups = [
    "input"
    "video"
    "libvirtd"
    "docker"
  ];

  home-manager.users.jp = {
    imports = with profiles.home; [
      dunst
      fish
      neovim
      niri
      waybar
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
    home.keyboard = null;
    home.stateVersion = "21.11";
  };

  environment.systemPackages = with pkgs; [
    # dev machine
    git
    riff
    # virtualization
    virt-manager

    # gebaar

    jellyfin-media-player
    # For debugging and troubleshooting Secure Boot.
    pkgs.sbctl
  ];

  # virtualization
  programs.dconf.enable = true;
  virtualisation = {
    libvirtd.enable = true;
  };

  virtualisation.docker = {
    enable = true;
    enableOnBoot = false;
  };

  services.fwupd.enable = true;

  boot.plymouth.enable = true;
  boot.initrd.systemd.enable = true;

  hardware.enableRedistributableFirmware = true;
}
