{ pkgs, lib, ... }:

{
  nixpkgs.overlays = [
    (final: prev: {
      albert = prev.albert.overrideAttrs rec {
        version = "0.26.10";
        src = final.fetchFromGitHub {
          owner = "albertlauncher";
          repo = "albert";
          rev = "v${version}";
          hash = "sha256-GVYRcrSXz4EXb3isoUN3x/68CAfr0wMgnvv+CzW/yZY=";
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
        version = "0.10.0";
        src = final.fetchFromGitHub {
          owner = "woodruffw";
          repo = "zizmor";
          rev = "refs/tags/v${version}";
          hash = "sha256-fq+J1+CrxFSbCimM8SIshwQciEjRjPcjAmdVKbVV13s=";
        };
        cargoHash = "sha256-OUwl9vBB8jMY40SbOc9YK4yyxvgWQTgQRWw2LN07W08=";
        cargoDeps = final.rustPlatform.fetchCargoTarball {
          inherit pname version src;
          hash = cargoHash;
        };
      });
    })
  ];
}
