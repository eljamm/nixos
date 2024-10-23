{ pkgs, lib, ... }:

{
  nixpkgs.overlays = [
    # albert launcher
    (final: prev: {
      albert = prev.albert.overrideAttrs rec {
        version = "0.26.5";
        src = final.fetchFromGitHub {
          owner = "albertlauncher";
          repo = "albert";
          rev = "v${version}";
          hash = "sha256-0ONnG3BOqHa0KqjqvGVEflYqtpo3Wt4duMBDXXHUZEk=";
          fetchSubmodules = true;
        };
      };
    })
  ];
}
