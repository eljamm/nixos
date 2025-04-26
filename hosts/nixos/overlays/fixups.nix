{ pkgs, lib, ... }:

{
  nixpkgs.overlays = [
    # Make kitty not freeze when using PaperWM with multi-monitors
    # https://github.com/kovidgoyal/kitty/issues/3069
    (final: prev: {
      kitty = prev.kitty.overrideAttrs (oldAttrs: {
        patches = (oldAttrs.patches or [ ]) ++ [
          ./patches/kitty/0002-revert-Wayland-suspend.patch
        ];
      });
    })
    # TODO: remove after this reaches unstable
    # https://github.com/NixOS/nixpkgs/pull/400902
    (final: prev: {
      furnace = prev.furnace.overrideAttrs (oldAttrs: {
        buildInputs = oldAttrs.buildInputs ++ [
          pkgs.libGL
          pkgs.xorg.libX11
        ];
      });
    })
    (final: prev: {
      freetube = prev.freetube.overrideAttrs (
        finalAttrs: _: {
          pname = "freetube";
          version = "0.23.3";
          src = final.fetchFromGitHub {
            owner = "FreeTubeApp";
            repo = "FreeTube";
            tag = "v${finalAttrs.version}-beta";
            hash = "sha256-EpcYNUtGbEFvetroo1zAyfKxW70vD1Lk0aJKWcaV39I=";
          };
          yarnOfflineCache = final.fetchYarnDeps {
            yarnLock = "${finalAttrs.src}/yarn.lock";
            hash = "sha256-xiJGzvmfrvvB6/rdwALOxhWSWAZ31cbySYygtG8+QpQ=";
          };
        }
      );
    })
  ];
}
