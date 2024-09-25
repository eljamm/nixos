{ pkgs, lib, ... }:

{
  nixpkgs.overlays = [
    # albert launcher
    (final: prev: {
      albert = prev.albert.overrideAttrs rec {
        version = "0.26.4";
        src = final.fetchFromGitHub {
          owner = "albertlauncher";
          repo = "albert";
          rev = "v${version}";
          hash = "sha256-MEpBZV1Fxoq24eT1hgyrp33qcaLqmQ+aAP974Yn8d2g=";
          fetchSubmodules = true;
        };
      };
    })
  ];
}
