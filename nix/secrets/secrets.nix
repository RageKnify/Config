let
  hosts = {
    war =
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIq8BgoZjQqFP0/QDJJ7TIT3r2k89uj2XcKBm4v3G2f0";
    azazel =
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAII8oSR9FbFzjFYimyEw7qNA8pbnYHIiMt6/mZAKo3GBN";
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
  "azazel/mailIsaacHashedPassword.age".publicKeys =
    [ hosts.azazel users.jp_war ];
  "azazel/mailWarHashedPassword.age".publicKeys = [ hosts.azazel users.jp_war ];
  "azazel/azazelMailPassword.age".publicKeys = [ hosts.azazel users.jp_war ];
  "azazel/ovh.age".publicKeys = [ hosts.azazel users.jp_war ];
  "azazel/resticPassword.age".publicKeys = [ hosts.azazel users.jp_war ];
  "azazel/backupEnvFile.age".publicKeys = [ hosts.azazel users.jp_war ];
  "azazel/registryPassword.age".publicKeys = [ hosts.azazel users.jp_war ];
  "azazel/discordTokenEnv.age".publicKeys = [ hosts.azazel users.jp_war ];

  "war/wireguard-privkey.age".publicKeys = [ hosts.war ];
  "war/resticPassword.age".publicKeys = [ hosts.war users.jp_war ];
  "war/backupEnvFile.age".publicKeys = [ hosts.war users.jp_war ];
  "war/warMailPassword.age".publicKeys = [ hosts.war users.jp_war ];
}
