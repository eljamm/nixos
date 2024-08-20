{ pkgs, lib, ... }:

{
  nixpkgs.overlays = [
    # albert launcher
    (_: prev: {
      albert = prev.albert.overrideAttrs rec {
        version = "0.26.0";
        src = prev.fetchFromGitHub {
          owner = "albertlauncher";
          repo = "albert";
          rev = "v${version}";
          hash = "sha256-OdRx8fev0weXgSMEUhSm7aESN2W3BVnJpgtrlEUo+L0=";
          fetchSubmodules = true;
        };
      };
    })

    # llama-cpp
    (_: prev: {
      llama-cpp =
        (prev.llama-cpp.overrideAttrs (
          finalAttrs: _: {
            version = "3581";
            src = prev.fetchFromGitHub {
              owner = "ggerganov";
              repo = "llama.cpp";
              rev = "refs/tags/b${finalAttrs.version}";
              hash = "sha256-gkOQwFOICdp7hrxi9XaUYWfKA+30esy5PxIIO8l6Rlc=";
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

    # taskwarrior3
    (_: prev: {
      taskwarrior3 = prev.taskwarrior3.overrideAttrs rec {
        pname = "taskwarrior";
        version = "3.1.0";
        src = prev.fetchFromGitHub {
          owner = "GothenburgBitFactory";
          repo = "taskwarrior";
          rev = "v${version}";
          hash = "sha256-iKpOExj1xM9rU/rIcOLLKMrZrAfz7y9X2kt2CjfMOOQ=";
          fetchSubmodules = true;
        };
        preCheck = "";
        checkTarget = "build_tests";
        cargoDeps = prev.rustPlatform.fetchCargoTarball {
          name = "${pname}-${version}-cargo-deps";
          inherit src;
          sourceRoot = src.name;
          hash = "sha256-L+hYYKXSOG4XYdexLMG3wdA7st+A9Wk9muzipSNjxrA=";
        };
      };
    })
  ];
}
