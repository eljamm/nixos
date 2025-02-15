{ pkgs, lib, ... }:

{
  nixpkgs.overlays = [
    (final: prev: {
      albert = prev.albert.overrideAttrs rec {
        version = "0.26.13";
        src = final.fetchFromGitHub {
          owner = "albertlauncher";
          repo = "albert";
          tag = "v${version}";
          hash = "sha256-p/8kCj9dN9x7gEvXnHGABL9Ab5zUJP5jI2L6AvCT8Qs";
          fetchSubmodules = true;
        };
      };
    })
    (final: prev: {
      neovim-unwrapped = prev.neovim-unwrapped.overrideAttrs (
        _: finalAttrs: {
          version = "0.10.3";
          src = final.fetchFromGitHub {
            owner = "neovim";
            repo = "neovim";
            tag = "v${finalAttrs.version}";
            hash = "sha256-nmnEyHE/HcrwK+CyJHNoLG0BqjnWleiBy0UYcJL7Ecc=";
          };
        }
      );
    })
    (final: prev: {
      zizmor = prev.zizmor.overrideAttrs (oldAttrs: rec {
        pname = "zizmor";
        version = "1.2.2";
        src = final.fetchFromGitHub {
          owner = "woodruffw";
          repo = "zizmor";
          tag = "v${version}";
          hash = "sha256-J2pKaGPbRYWlupWHeXbDpxMDpWk+Px0yuKsH6wiFq5M=";
        };
        cargoHash = "sha256-YrQBR5RVBAqYqdAucRiqO8cFmgdVvqA8HEYOXFieSsU=";
        cargoDeps = final.rustPlatform.fetchCargoTarball {
          inherit pname version src;
          hash = cargoHash;
        };
      });
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
    (final: prev: {
      unciv = prev.unciv.overrideAttrs rec {
        version = "4.15.9-patch1";
        src = final.fetchurl {
          url = "https://github.com/yairm210/Unciv/releases/download/${version}/Unciv.jar";
          hash = "sha256-HozoaTAKS/pO/xFLCoXUvrvEEd85oMMxkZ6fFDgSfvQ=";
        };
      };
    })
  ];
}
