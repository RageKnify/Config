let
  hosts = {
    war =
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIq8BgoZjQqFP0/QDJJ7TIT3r2k89uj2XcKBm4v3G2f0";
    azazel =
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAII8oSR9FbFzjFYimyEw7qNA8pbnYHIiMt6/mZAKo3GBN";
    conquest =
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGdLF/miwKkDhgRDieE4zMsr4i2G/rCBu1JjrpAsx7GB";
  };
  users = {
    jp_war =
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIC2sdJFvvnEIYztPcznXvKpY4vOWedZ1qzDaAgRxrczS";
  };
in {
  "azazel/mailJoaoHashedPassword.age".publicKeys =
    [ hosts.azazel users.jp_war ];
  "azazel/mailAzazelHashedPassword.age".publicKeys =
    [ hosts.azazel users.jp_war ];
  "azazel/mailConquestHashedPassword.age".publicKeys =
    [ hosts.azazel users.jp_war ];
  "azazel/mailWarHashedPassword.age".publicKeys = [ hosts.azazel users.jp_war ];
  "azazel/azazelMailPassword.age".publicKeys = [ hosts.azazel users.jp_war ];
  "azazel/ritaAuthFile.age".publicKeys = [ hosts.azazel users.jp_war ];
  "azazel/ovh.age".publicKeys = [ hosts.azazel users.jp_war ];
  "azazel/resticPassword.age".publicKeys = [ hosts.azazel users.jp_war ];
  "azazel/backupEnvFile.age".publicKeys = [ hosts.azazel users.jp_war ];

  "conquest/registryPassword.age".publicKeys = [ hosts.conquest users.jp_war ];
  "conquest/discordTokenEnv.age".publicKeys = [ hosts.conquest users.jp_war ];
  "conquest/resticPassword.age".publicKeys = [ hosts.conquest users.jp_war ];
  "conquest/backupEnvFile.age".publicKeys = [ hosts.conquest users.jp_war ];
  "conquest/conquestMailPassword.age".publicKeys = [ hosts.conquest users.jp_war ];
  "conquest/nextcloud-admin-pass.age".publicKeys = [ hosts.conquest users.jp_war ];
  "conquest/firefly-secrets.age".publicKeys = [ hosts.conquest users.jp_war ];
  "conquest/ovh.age".publicKeys = [ hosts.conquest users.jp_war ];

  "war/wireguard-privkey.age".publicKeys = [ hosts.war ];
  "war/resticPassword.age".publicKeys = [ hosts.war users.jp_war ];
  "war/backupEnvFile.age".publicKeys = [ hosts.war users.jp_war ];
  "war/warMailPassword.age".publicKeys = [ hosts.war users.jp_war ];
}
