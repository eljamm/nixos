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
          version = "0.32.1";
          src = final.fetchFromGitHub {
            owner = "albertlauncher";
            repo = "albert";
            tag = "v${finalAttrs.version}";
            hash = "sha256-v2SMY0KGFwwybsiMu1W1wBWdyoDEFF3hWd4LeaT8Nts=";
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
      readest = prev.readest.overrideAttrs (
        finalAttrs: oldAttrs: {
          version = "0.9.78";
          src = final.fetchFromGitHub {
            owner = "readest";
            repo = "readest";
            tag = "v${finalAttrs.version}";
            hash = "sha256-sKk/NwnD9asIqDW75FI7xZf3zNavlorbK08ff+v4O3g=";
            fetchSubmodules = true;
          };
          pnpmDeps = final.pnpm_9.fetchDeps {
            inherit (finalAttrs) pname version src;
            fetcherVersion = 1;
            hash = "sha256-3H+HEQcXUbmTp+Gu7xz/NpxJgrnw1ubWH79yYKhFTeM=";
          };
          cargoDeps = final.rustPlatform.fetchCargoVendor {
            inherit (finalAttrs) src;
            hash = "sha256-7q75xX3aDDvcNkEZEM62icFuiMY4mzv+k3C+fGBLwIg=";
          };
        }
      );
    })
  ];
}
