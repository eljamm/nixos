{ pkgs, ... }:
with pkgs;
{
  nixpkgs.overlays = [
    # FIX: wait for next release
    (final: prev: { redlib = callPackage ./re/redlib/package.nix { }; })
  ];
}
