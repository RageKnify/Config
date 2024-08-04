{ pkgs, lib, config, ... }:
let interfaceName = "bible";
in {
  services.tailscale = {
    inherit interfaceName;
    enable = true;
  };

  networking.firewall = {
    trustedInterfaces = [ interfaceName ];
    allowedUDPPorts = [ config.services.tailscale.port ];
  };

  environment.persistence."/persist".directories = [ "/var/lib/tailscale" ];

  modules.services.backups.paths = [ "/persist/var/lib/tailscale/" ];
}
