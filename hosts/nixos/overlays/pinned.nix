{ pkgs, lib, ... }:

{
  nixpkgs.overlays = [
    (final: prev: {
      albert = prev.albert.overrideAttrs rec {
        version = "0.26.11";
        src = final.fetchFromGitHub {
          owner = "albertlauncher";
          repo = "albert";
          rev = "v${version}";
          hash = "sha256-rPQ6nxUT7qiuOgmmQKCrYHl4kKJODe+nw4VNGjF+n/g=";
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
        version = "1.0.1";
        src = final.fetchFromGitHub {
          owner = "woodruffw";
          repo = "zizmor";
          rev = "refs/tags/v${version}";
          hash = "sha256-1NpwBjJlpaP3iyTfrgMwO/1qR74/MNBYjtf4+wCe4m8=";
        };
        cargoHash = "sha256-feAfHkcLvEdFblehPGtLO01Vl9QpOueuJrpEujlv4qY=";
        cargoDeps = final.rustPlatform.fetchCargoTarball {
          inherit pname version src;
          hash = cargoHash;
        };
      });
    })
  ];
}
