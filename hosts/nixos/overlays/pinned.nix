{ pkgs, lib, ... }:

{
  nixpkgs.overlays = [
    (final: prev: {
      albert = prev.albert.overrideAttrs (
        finalAttrs: oldAttrs: {
          version = "0.32.1";
          src = final.fetchFromGitHub {
            owner = "albertlauncher";
            repo = "albert";
            tag = "v${finalAttrs.version}";
            hash = "sha256-v2SMY0KGFwwybsiMu1W1wBWdyoDEFF3hWd4LeaT8Nts=";
            fetchSubmodules = true;
          };

          buildInputs = (oldAttrs.buildInputs or [ ]) ++ [ pkgs.kdePackages.qtkeychain ];
        }
      );
    })
  ];
}
