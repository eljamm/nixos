{ pkgs, lib, ... }:

{
  nixpkgs.overlays = [
    (final: prev: {
      albert = prev.albert.overrideAttrs (
        finalAttrs: oldAttrs: {
          version = "0.28.2";
          src = final.fetchFromGitHub {
            owner = "albertlauncher";
            repo = "albert";
            tag = "v${finalAttrs.version}";
            hash = "sha256-FYl/S7+KoQ3kgUQX0hiv8B+AbTbyfmo1GX130G09bZ8=";
            fetchSubmodules = true;
          };

          buildInputs = (oldAttrs.buildInputs or [ ]) ++ [ pkgs.kdePackages.qtkeychain ];
        }
      );
    })
  ];

  environment.systemPackages = [
    (pkgs.callPackage ./patches/lmstudio.nix { })
  ];
}
