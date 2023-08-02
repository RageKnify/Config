{ pkgs, lib, config, ... }:
let domain = "headscale.jborges.eu";
in {
  services = {
    headscale = {
      enable = true;
      address = "[::1]";
      settings = {
        server_url = "https://${domain}";
        ip_prefixes = [ "100.64.0.0/10" "fd7a:115c:a1e0::/48" ];
        dns_config = {
          base_domain = "jborges.eu";
          magic_dns = true;
          name_servers = [ "1.1.1.1" ];
          override_local_dns = true;
        };
      };
    };

    nginx.virtualHosts.${domain} = {
      forceSSL = true;
      useACMEHost = "jborges.eu";
      locations."/" = {
        proxyPass = "http://${config.services.headscale.settings.listen_addr}";
        proxyWebsockets = true;
      };
    };
  };

  environment.systemPackages = [ config.services.headscale.package ];

  environment.persistence."/persist".directories = [{
    directory = "/var/lib/headscale";
    user = "headscale";
    group = "headscale";
  }];

  modules.services.backups.paths = [ "/persist/var/lib/headscale/" ];
}
