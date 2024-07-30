{ pkgs, lib, ... }:

{
  nixpkgs.overlays = [
    # albert launcher
    (_: prev: {
      albert = prev.albert.overrideAttrs rec {
        version = "0.24.3";
        src = prev.fetchFromGitHub {
          owner = "albertlauncher";
          repo = "albert";
          rev = "v${version}";
          hash = "sha256-9vR6G/9FSy1mqZCo19Mf0RuvW63DbnhEzp/h0p6eXqs=";
          fetchSubmodules = true;
        };
      };
    })

    # llama-cpp
    (_: prev: {
      llama-cpp =
        (prev.llama-cpp.overrideAttrs (
          finalAttrs: _: {
            src = {
              version = "3403";
              owner = "ggerganov";
              repo = "llama.cpp";
              rev = "refs/tags/b${finalAttrs.version}";
              hash = "sha256-0KVwSzxfGinpv5KkDCgF2J+1ijDv87PlDrC+ldscP6s=";
              leaveDotGit = true;
            };
          }
        )).override
          { cudaSupport = true; };
    })
  ];
}
