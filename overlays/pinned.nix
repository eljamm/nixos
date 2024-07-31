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
            version = "3403";
            src = prev.fetchFromGitHub {
              owner = "ggerganov";
              repo = "llama.cpp";
              rev = "refs/tags/b${finalAttrs.version}";
              hash = "sha256-+WWJyEt04ZUC/vh9ZReLek851iOZJYoGc49XJyRPkVE=";
              leaveDotGit = true;
              postFetch = ''
                git -C "$out" rev-parse --short HEAD > $out/COMMIT
                find "$out" -name .git -print0 | xargs -0 rm -rf
              '';
            };
          }
        )).override
          { cudaSupport = true; };
    })
  ];
}
