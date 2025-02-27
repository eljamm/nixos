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
    (final: prev: {
      freetube = prev.freetube.overrideAttrs (
        finalAttrs: _: {
          pname = "freetube";
          version = "0.23.2";
          src = final.fetchFromGitHub {
            owner = "FreeTubeApp";
            repo = "FreeTube";
            tag = "v${finalAttrs.version}-beta";
            hash = "sha256-P0ENx8PDWbqfiBEsWv11R3Q/FE+rAFhhk49VyQgXIz4=";
          };
          yarnOfflineCache = final.fetchYarnDeps {
            yarnLock = "${finalAttrs.src}/yarn.lock";
            hash = "sha256-U6H4TMKR+khs5fQtMtIBnHpAzJvHcvMeSD1XUqaov/M=";
          };
        }
      );
    })
  ];
}
