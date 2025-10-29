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
          version = "0.9.91";
          src = final.fetchFromGitHub {
            owner = "readest";
            repo = "readest";
            tag = "v${finalAttrs.version}";
            hash = "sha256-Xz+s+yv0L2bj7T6GA6IkMGTAk2oGyFuYR5zzyeLbTuc=";
            fetchSubmodules = true;
          };
          pnpmDeps = final.pnpm_9.fetchDeps {
            inherit (finalAttrs) pname version src;
            fetcherVersion = 1;
            hash = "sha256-RsmI0avMnVWlLMzwGJJmPNSEJpNaq7IWimjpMJ+nR80=";
          };
          cargoDeps = final.rustPlatform.fetchCargoVendor {
            inherit (finalAttrs) src;
            hash = "sha256-nNMD2LnMDz91kI2QniD+zD/Ug9BSVjTIiuxWdz8UxL0=";
          };
        }
      );
    })
    (final: prev: {
      yt-dlp = prev.yt-dlp.overridePythonAttrs (oldAttrs: rec {
        version = "2025.10.14";
        src = final.fetchFromGitHub {
          owner = "yt-dlp";
          repo = "yt-dlp";
          tag = version;
          hash = "sha256-x7vpuXUihlC4jONwjmWnPECFZ7xiVAOFSDUgBNvl+aA=";
        };
      });
    })
    (final: prev: {
      linux_xanmod_custom =
        let
          version = "6.17.4";
          hash = "sha256-UHfZwK0qIVhiKw8OpE8i+V2BRav6Fsju8E5rO5WRwVA=";
          modDirVersion = "${version}-xanmod1";
          kernel = prev.linux_xanmod_latest;
        in
        kernel.override {
          argsOverride = {
            inherit version modDirVersion;

            src = final.fetchFromGitLab {
              owner = "xanmod";
              repo = "linux";
              rev = modDirVersion;
              inherit hash;
            };

            structuredExtraConfig =
              with lib.kernel;
              pkgsUnstable.linux_xanmod_latest.structuredExtraConfig
              // {
                NTSYNC = yes;
              };
          };
        };
      linux_xanmod_custom-packages = final.linuxPackagesFor final.linux_xanmod_custom;
    })
  ];
}
