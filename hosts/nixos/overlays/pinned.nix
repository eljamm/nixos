{
  lib,
  pkgs,
  config,
  pkgsUnstable,
  ...
}:

{
  nixpkgs.overlays = [
    (final: prev: {
      nix = config.nix.package;
      nixVersions = pkgsUnstable.nixVersions;
    })
    (final: prev: {
      albert = prev.albert.overrideAttrs (
        finalAttrs: oldAttrs: {
          version = "33.0.1";
          src = final.fetchFromGitHub {
            owner = "albertlauncher";
            repo = "albert";
            tag = "v${finalAttrs.version}";
            hash = "sha256-zHLyvFzLR7Ryk6eoD+Lp+w4bIj7MAeREK0YzRXYnx6c=";
            fetchSubmodules = true;
          };

          buildInputs = (oldAttrs.buildInputs or [ ]) ++ [ pkgs.kdePackages.qtkeychain ];
        }
      );
    })
    (final: prev: {
      freetube = prev.freetube.overrideAttrs (
        finalAttrs: _: {
          pname = "freetube";
          version = "0.23.12";
          src = final.fetchFromGitHub {
            owner = "FreeTubeApp";
            repo = "FreeTube";
            tag = "v${finalAttrs.version}-beta";
            hash = "sha256-DH5uT3dPDFZnFYoiMjxpNouNDRbWDctVqvDwHpUlnkY=";
          };
          yarnOfflineCache = final.fetchYarnDeps {
            yarnLock = "${finalAttrs.src}/yarn.lock";
            hash = "sha256-sM9CkDnATSEUf/uuUyT4JuRmjzwa1WzIyNYEw69MPtU=";
          };
        }
      );
    })
    (final: prev: {
      readest = pkgsUnstable.readest.overrideAttrs (
        finalAttrs: oldAttrs: {
          version = "0.9.88";
          src = final.fetchFromGitHub {
            owner = "readest";
            repo = "readest";
            tag = "v${finalAttrs.version}";
            hash = "sha256-z9bRRXQkXsqZRW1EPj0c8A9ZHWytYYtP6o40K86+Fio=";
            fetchSubmodules = true;
          };
          pnpmDeps = final.pnpm_9.fetchDeps {
            inherit (finalAttrs) pname version src;
            fetcherVersion = 1;
            hash = "sha256-sRa1IO8JmMsA0/7dMuYF0as/MYHpclEwAknZIycNQ3Y=";
          };
          cargoDeps = final.rustPlatform.fetchCargoVendor {
            inherit (finalAttrs) src;
            hash = "sha256-oNzgsxJb8N++AGCkXuJmK+51iF7XZ0xmShPlOpkAQEg=";
          };
        }
      );
    })
    (final: prev: {
      yt-dlp = prev.yt-dlp.overridePythonAttrs (oldAttrs: rec {
        version = "2025.09.26";
        src = final.fetchFromGitHub {
          owner = "yt-dlp";
          repo = "yt-dlp";
          tag = version;
          hash = "sha256-/uzs87Vw+aDNfIJVLOx3C8RyZvWLqjggmnjrOvUX1Eg=";
        };
      });
    })
  ];
}
