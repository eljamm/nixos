{ pkgs, lib, ... }:

{
  nixpkgs.overlays = [
    # albert launcher
    (final: prev: {
      albert = prev.albert.overrideAttrs rec {
        version = "0.26.6";
        src = final.fetchFromGitHub {
          owner = "albertlauncher";
          repo = "albert";
          rev = "v${version}";
          hash = "sha256-Z4YgqqtJPYMzpnMt74TX2Hi0AEMyhRc2QHSVuwuaxfE=";
          fetchSubmodules = true;
        };
      };
    })
  ];
}
