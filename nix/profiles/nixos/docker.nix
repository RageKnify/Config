{
  config,
  lib,
  pkgs,
  ...
}:
{
  virtualisation = {
    docker = {
      enable = true;
      autoPrune.enable = true;
      storageDriver = "zfs";
    };

    oci-containers.backend = "docker";
  };

  environment.persistence."/persist".directories = [ { directory = "/var/lib/docker"; } ];
}
