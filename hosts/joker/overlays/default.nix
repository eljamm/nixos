{ pkgs, ... }:

{
  imports = [
    ./pinned.nix
    ./fixups.nix
  ];
}
