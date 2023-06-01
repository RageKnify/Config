# hosts/war/system.nix
#
# Author: João Borges <RageKnify@gmail.com>
# URL:    https://github.com/RageKnify/Config
#
# System configuration.

{ config, pkgs, lib, configDir, user, ... }:
{
  modules = {
    graphical.enable = true;
    personal.enable = true;
    kanata = {
      enable = true;
      normal_device = "/dev/input/by-path/platform-i8042-serio-0-event-kbd";
    };
    syncthing.enable = true;
  };

  console.useXkbConfig = true;

  location = {
    provider = "manual";
    # Lisboa, Portugal
    latitude = 38.43;
    longitude = -9.8;
  };

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
      enable = true;
      editor = false;
      consoleMode = "auto";
      configurationLimit = 20;
    };
    timeout = 2;
    efi.canTouchEfiVariables = true;
  };

  boot.supportedFilesystems = [ "zfs" ];
  boot.kernelParams = [ "nohibernate" ];
  boot.zfs.devNodes = "/dev";

  services.zfs = {
    trim.enable = true;
    autoScrub.enable = true;
    autoScrub.pools = [ "rpool" ];
  };

  networking.hostId = "48a4b691";
  networking.networkmanager = {
    enable = true;
  };
  services.resolved = {
    enable = true;
    fallbackDns = [
      "1.1.1.1"
      "1.0.0.1"
      "2606:4700:4700::1111"
      "2606:4700:4700::1001"
    ];
  };
  networking.firewall.checkReversePath = "loose";
  systemd.network = let
    rnlFwmark = 765;
    sttFwmark = 577;
    in {
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
        PrivateKeyFile = "/etc/nixos/secrets/wg-privkey";
        FirewallMark = rnlFwmark;
        RouteTable = "rnl";
      };
      wireguardPeers = [{
        wireguardPeerConfig = {
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
        };
      }];
    };
    netdevs."20-stt" = {
      enable = true;
      netdevConfig = {
        Kind = "wireguard";
        MTUBytes = "1300";
        Name = "stt";
      };
      wireguardConfig = {
        PrivateKeyFile = "/etc/nixos/secrets/wg-privkey";
        FirewallMark = sttFwmark;
        RouteTable = "stt";
      };
      wireguardPeers = [{
        wireguardPeerConfig = {
          PublicKey = "u0DdfahuhX8GsVaQ4P2kBcHoF9kw9HZL9uqPcu2UMw8=";
          Endpoint = "pest.stt.rnl.tecnico.ulisboa.pt:34266";
          AllowedIPs = [
            "10.0.0.0/8"
            "fd00::/8"
          ];
          PersistentKeepalive = 25;
        };
      }];
    };
    networks."40-rnl" = {
      name = "rnl";

      addresses = [
        { addressConfig.Address = "192.168.20.13/24"; }
        {
          addressConfig.Address = "fd92:3315:9e43:c490::13/64";
          #addressConfig.DuplicateAddressDetection = "none";
        }
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
          routingPolicyRuleConfig = {
            InvertRule = true;
            FirewallMark = rnlFwmark;
            Table = "rnl";
          };
        }
      ];

      ntp = [ "ntp.rnl.tecnico.ulisboa.pt" ];

      dns = [
        "2001:690:2100:80::1"
        "193.136.164.2"
        "2001:690:2100:80::2"
        "193.136.164.1"
      ];
      domains = [
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

        # resolve any other domain by default
        "~."

      ] ++ (
        # private ranges (DSI-assigned)
        builtins.map
        (octet: "~" + (builtins.toString octet) + ".16.10.in-addr.arpa")
        (lib.range 64 127));
    };
    networks."50-stt" = {
      name = "stt";

      addresses = [
        { addressConfig.Address = "10.6.77.100/8"; }
        { addressConfig.Address = "fd00:677::100/8"; }
      ];

      networkConfig = {
        LinkLocalAddressing = "no";
        IPv6AcceptRA = false;
        #MulticastDNS = true;
      };

      routingPolicyRules = [
        {
          routingPolicyRuleConfig = {
            InvertRule = true;
            FirewallMark = sttFwmark;
            Table = "stt";
          };
        }
      ];

      dns = [ "10.6.77.1" ];
      domains = [
        "~stt.pt"
      ];

      extraConfig = ''
      [Network]
      DNSSEC=false
      '';
    };
  };

  users.users.root.hashedPassword = "$6$wlIVxKTns9xQ3Rc4$fbiA/wXnZ0l9TXKr90KmNVSltyU.MOH2Si8ntvLXINKGpug82rpFABP.PXAOp6Qtbq.onD8qAaSpq.TaKOmgj1";
  users.users.jp.extraGroups = [ "video" "libvirtd" "docker" ];

  environment.systemPackages = with pkgs; [
    # dev machine
    git
    riff
    # virtualization
    virt-manager

    jellyfin-media-player
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
