{ config, pkgsUnstable, ... }:

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
          version = "0.23.8";
          src = final.fetchFromGitHub {
            owner = "FreeTubeApp";
            repo = "FreeTube";
            tag = "v${finalAttrs.version}-beta";
            hash = "sha256-CHp/6/E/v6UdSe3xoB66Ot24WuZDPdmNyUG1w2w3bX0=";
          };
          yarnOfflineCache = final.fetchYarnDeps {
            yarnLock = "${finalAttrs.src}/yarn.lock";
            hash = "sha256-ia5wLRt3Hmo4/dsB1/rhGWGJ7LMnVR9ju9lSlQZDTTg=";
          };
        }
      );
    })
    (final: prev: {
      nix = config.nix.package;
      nixVersions = pkgsUnstable.nixVersions;
    })
    (final: prev: {
      yt-dlp = prev.yt-dlp.overridePythonAttrs (oldAttrs: rec {
        version = "2025.08.11";
        src = final.fetchFromGitHub {
          owner = "yt-dlp";
          repo = "yt-dlp";
          tag = version;
          hash = "sha256-j7x844MPPFdXYTJiiMnru3CE79A/6JdfJDdh8it9KsU=";
        };
      });
    })
  ];
}
