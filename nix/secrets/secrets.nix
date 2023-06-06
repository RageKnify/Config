let
  hosts = {
    lazarus =
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIII5eWrA8c9LJzVw/jV6CvMTDecRbcVBufdqUNIZVvBu";
    war =
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIq8BgoZjQqFP0/QDJJ7TIT3r2k89uj2XcKBm4v3G2f0";
  };
  users = {
    jp_war =
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIC2sdJFvvnEIYztPcznXvKpY4vOWedZ1qzDaAgRxrczS";
  };
in {
  "lazarus/restic_default_password.age".publicKeys =
    [ hosts.lazarus users.jp_war ];
  "war/wireguard-privkey.age".publicKeys = [ hosts.war ];
}
