{ pkgs, ... }:
with pkgs;
{
  nixpkgs.overlays = [
    (final: prev: { cinny-desktop = callPackage ./ci/cinny-desktop/package.nix { }; })
  ];
}
