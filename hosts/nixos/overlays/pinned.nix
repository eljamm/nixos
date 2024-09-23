{ pkgs, lib, ... }:

{
  nixpkgs.overlays = [
    # albert launcher
    (final: prev: {
      albert = prev.albert.overrideAttrs rec {
        version = "0.26.2";
        src = final.fetchFromGitHub {
          owner = "albertlauncher";
          repo = "albert";
          rev = "v${version}";
          hash = "sha256-jgSa1IvpMlwtpNT/SEysG28qaszV7gH6ZSqGrHQ/EC0=";
          fetchSubmodules = true;
        };
      };
    })
  ];
}
