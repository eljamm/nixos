{ pkgs, lib, ... }:
{
  imports = [
    ./dconf.nix
    ./theme.nix
  ];
}
