{
  config,
  lib,
  pkgs,
  ...
}:
{
  networking = {
    nameservers = [ "127.0.0.2" ];
    # If using dhcpcd:
    dhcpcd.extraConfig = "nohook resolv.conf";
  };
  services.resolved = {
    enable = true;
    domains = [ "~." ];
    fallbackDns = [
      "1.1.1.3#family.cloudflare-dns.com"
      "1.0.0.3#family.cloudflare-dns.com"
      "2606:4700:4700::1113#family.cloudflare-dns.com"
      "2606:4700:4700::1003#family.cloudflare-dns.com"
    ];
  };
  services.dnscrypt-proxy2 = {
    enable = true;
    settings = {
      listen_addresses = [ "127.0.0.2:53" ];
      require_dnssec = true;
      require_nofilter = false;
      http3 = true;

      bootstrap_resolvers = [
        "1.1.1.3:53"
        "1.0.0.3:53"
      ];
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
