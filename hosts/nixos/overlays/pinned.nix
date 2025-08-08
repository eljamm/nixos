{ pkgs, lib, ... }:

{
  nixpkgs.overlays = [
    (final: prev: {
      albert = prev.albert.overrideAttrs (
        finalAttrs: oldAttrs: {
          version = "0.31.1";
          src = final.fetchFromGitHub {
            owner = "albertlauncher";
            repo = "albert";
            tag = "v${finalAttrs.version}";
            hash = "sha256-7YtDC0Xkv2y7vF58j78GsOPAMSvuwTmEobHULDBt9BI=";
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
