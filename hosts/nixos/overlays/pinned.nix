{ pkgs, lib, ... }:

{
  nixpkgs.overlays = [
    (final: prev: {
      albert = prev.albert.overrideAttrs (
        finalAttrs: oldAttrs: {
          version = "0.30.1";
          src = final.fetchFromGitHub {
            owner = "albertlauncher";
            repo = "albert";
            tag = "v${finalAttrs.version}";
            hash = "sha256-EscR31DZzLszs2jPQDDcB7SFtSuWPjSBpjJw8i+PsD0=";
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
