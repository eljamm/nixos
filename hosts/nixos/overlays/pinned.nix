{ pkgs, lib, ... }:

{
  nixpkgs.overlays = [
    (final: prev: {
      albert = prev.albert.overrideAttrs rec {
        version = "0.27.5";
        src = final.fetchFromGitHub {
          owner = "albertlauncher";
          repo = "albert";
          tag = "v${version}";
          hash = "sha256-rdBNh9TICeOpglaJ5OJbE/f4W/UPqCkhp8H/H2OBTRM=";
          fetchSubmodules = true;
        };
      };
    })
    (final: prev: {
      llama-cpp = prev.llama-cpp.overrideAttrs (
        oldAttrs: finalAttrs: {
          version = "4588";
          src = final.fetchFromGitHub {
            owner = "ggerganov";
            repo = "llama.cpp";
            tag = "b${finalAttrs.version}";
            hash = "sha256-rttgk8mF9s3R53+TN5+PdDtkTG5cohn/9wz9Z5gRpdM=";
            leaveDotGit = true;
            postFetch = ''
              git -C "$out" rev-parse --short HEAD > $out/COMMIT
              find "$out" -name .git -print0 | xargs -0 rm -rf
            '';
          };
        }
      );
    })
  ];

  environment.systemPackages = [
    (pkgs.callPackage ./patches/lmstudio.nix { })
  ];
}
