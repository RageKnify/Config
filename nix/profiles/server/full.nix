# profiles/server/full.nix
#
# Author: João Borges <RageKnify@gmail.com>
# URL:    https://github.com/RageKnify/Config
#
# full server config

{ profiles, ... }:
{
  imports = with profiles; [ server.sshd server.autoUpgrade server.nix-gc ];
}
