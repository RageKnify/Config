let
  hosts = {
    lazarus = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIII5eWrA8c9LJzVw/jV6CvMTDecRbcVBufdqUNIZVvBu";
  };
  users = {
    jp_war = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIC2sdJFvvnEIYztPcznXvKpY4vOWedZ1qzDaAgRxrczS";
  };
in {
  "lazarus/restic_default_password.age".publicKeys = [
    hosts.lazarus
    users.jp_war
  ];
}
