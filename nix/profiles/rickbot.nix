{ config, lib, pkgs, hostSecretsDir, ... }: {
  age.secrets = {
    registryPassword.file = "${hostSecretsDir}/registryPassword.age";
    discordTokenEnv.file = "${hostSecretsDir}/discordTokenEnv.age";
  };

  virtualisation.oci-containers.containers.rickbot = {
    image = "ghcr.io/rickvieira21/rickbot:latest";
    environmentFiles = [
      config.age.secrets.discordTokenEnv.path
    ];
    login = {
      username = "RageKnify";
      registry = "ghcr.io";
      passwordFile = config.age.secrets.registryPassword.path;
    };
  };
}
