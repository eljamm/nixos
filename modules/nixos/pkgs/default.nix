{ pkgs, ... }:
with pkgs;
{
  nixpkgs.overlays = [
    (final: prev: { cinny-desktop = callPackage ./ci/cinny-desktop/package.nix { }; })
    # FIX: wait for next release
    (final: prev: { redlib = callPackage ./re/redlib/package.nix { }; })
  ];
}
