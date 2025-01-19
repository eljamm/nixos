{ pkgs, lib, ... }:

{
  nixpkgs.overlays = [
    (final: prev: {
      albert = prev.albert.overrideAttrs rec {
        version = "0.26.13";
        src = final.fetchFromGitHub {
          owner = "albertlauncher";
          repo = "albert";
          rev = "v${version}";
          hash = "sha256-p/8kCj9dN9x7gEvXnHGABL9Ab5zUJP5jI2L6AvCT8Qs=";
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
  ];
}
