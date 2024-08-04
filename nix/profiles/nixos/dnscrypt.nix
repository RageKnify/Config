{
  config,
  lib,
  pkgs,
  ...
}:
{
  networking = {
    nameservers = [
      "127.0.0.2"
    ];
    # If using dhcpcd:
    dhcpcd.extraConfig = "nohook resolv.conf";
  };
  services.resolved = {
    enable = true;
    dnssec = "true";
    domains = [ "~." ];
    extraConfig = ''
    DefaultRoute=true
    '';
  };
  services.dnscrypt-proxy2 = {
    enable = true;
    settings = {
      listen_addresses = [ "127.0.0.2:53" ];
      require_dnssec = true;
      require_nofilter = false;
      http3 = true;

      server_names = [
        "cloudflare-family"
        "cloudflare-family-ipv6"
      ];
    };
  };

  systemd.services.dnscrypt-proxy2.serviceConfig = {
    StateDirectory = "dnscrypt-proxy";
  };
}
