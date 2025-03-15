{ pkgs, ... }:

{
  imports = [
    ./pinned.nix
    ./fixups.nix
  ];

  # TODO: clean this up
  nixpkgs.overlays = [
    (final: prev: {
      ctranslate2 = prev.ctranslate2.override {
        withCUDA = true;
        withCuDNN = true;
      };
    })
  ];
}
