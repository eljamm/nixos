{
  lib,
  inputs,
  devLib,
  pkgs,
  config,
  pkgsUnstable,
  ...
}:

{
  nixpkgs.overlays = [
    (final: prev: {
      gwt = inputs.gowt.default;
    })
    (final: prev: {
      nix = config.nix.package;
      nixVersions = pkgsUnstable.nixVersions;
    })
    (final: prev: {
      albert = prev.albert.overrideAttrs (
        finalAttrs: oldAttrs: {
          version = "34.0.2";
          src = final.fetchFromGitHub {
            owner = "albertlauncher";
            repo = "albert";
            tag = "v${finalAttrs.version}";
            hash = "sha256-M4Chhl9pJcg2hFZB7se61FxhdPqMDRKxLhMonVOYZtY=";
            fetchSubmodules = true;
          };
          buildInputs = (oldAttrs.buildInputs or [ ]) ++ [ pkgs.kdePackages.qcoro ];
        }
      );
    })
    (final: prev: {
      freetube = devLib.newestPackage prev (
        prev.freetube.overrideAttrs (
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
        )
      );
    })
    (final: prev: {
      readest = devLib.newestPackage pkgsUnstable (
        pkgsUnstable.readest.overrideAttrs (
          finalAttrs: oldAttrs: {
            version = "0.9.98";
            src = final.fetchFromGitHub {
              owner = "readest";
              repo = "readest";
              tag = "v${finalAttrs.version}";
              hash = "sha256-qhV2ZEMcnn+0IePaIIvTcCYGCdLAUhtC0GEQAuXWUC8=";
              fetchSubmodules = true;
            };
            pnpmDeps = final.pnpm_9.fetchDeps {
              inherit (finalAttrs) pname version src;
              fetcherVersion = 1;
              hash = "sha256-3eYWN5ZZByOO2UFJ7X4PdBr/fNtnBmhrzx4J9IFxiNw=";
            };
            cargoDeps = final.rustPlatform.fetchCargoVendor {
              inherit (finalAttrs) src;
              hash = "sha256-qYBHYjwfGkKmGXN8caamZ6/XGtnxe+lmy6dIpdMwS/I=";
            };
          }
        )
      );
    })
    (final: prev: {
      yt-dlp = devLib.newestPackage prev (
        prev.yt-dlp.overrideAttrs (oldAttrs: rec {
          version = "2026.02.04";
          src = final.fetchFromGitHub {
            owner = "yt-dlp";
            repo = "yt-dlp";
            tag = version;
            hash = "sha256-KXnz/ocHBftenDUkCiFoBRBxi6yWt0fNuRX+vKFWDQw=";
          };
          prePatch = ''
            substituteInPlace yt_dlp/networking/_curlcffi.py \
              --replace-fail \
                "if curl_cffi_version != (0, 5, 10) and not (0, 10) <= curl_cffi_version < (0, 15)" \
                "if curl_cffi_version != (0, 5, 10) and not (0, 10) <= curl_cffi_version < (0, 14)"
          '';
        })
      );
      python3 = prev.python3.override {
        packageOverrides = pyfinal: pyprev: {
          yt-dlp-ejs = pyprev.yt-dlp-ejs.overridePythonAttrs (oldAttrs: rec {
            pname = "yt-dlp-ejs";
            version = "0.4.0";
            src = final.fetchFromGitHub {
              owner = "yt-dlp";
              repo = "ejs";
              tag = version;
              hash = "sha256-/qq069SD7ESg+7pK4PC1EGLLI8zqjWUse7cArN4YuXE=";
            };
          });
        };
      };
      python3Packages = final.python3.pkgs;
    })
    (final: prev: {
      linux_xanmod_custom =
        let
          version = "6.18.5";
          hash = "sha256-G3nG41foET2Ae84gLmB3P6GylnMN2Bp55bnXY/MNI+k=";
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
    (final: prev: {
      opencode = devLib.newestPackage pkgsUnstable (
        pkgsUnstable.opencode.overrideAttrs (oldAttrs: rec {
          version = "1.1.30";
          src = final.fetchFromGitHub {
            owner = "sst";
            repo = "opencode";
            tag = "v${version}";
            hash = "sha256-RTj64yrVLTFNpVc8MvPAJISOlBo/j2MnuL5jo4VtKWM=";
          };
          node_modules = oldAttrs.node_modules.overrideAttrs {
            inherit version src;
            outputHash = "sha256-37pmIiJzPEWeA7+5u5lz39vlFPI+N13Qw9weHrAaGW4=";
          };
          configurePhase = ''
            runHook preConfigure
            cp -R ${node_modules}/. .
            runHook postConfigure
          '';
        })
      );
    })
    (final: prev: {
      redlib = pkgsUnstable.redlib.overrideAttrs (oldAttrs: rec {
        version = "0.36.0-unstable-2025-10-06_2";
        src = final.fetchFromGitHub {
          owner = "redlib-org";
          repo = "redlib";
          rev = "2dc6b5f3c0db1f8e78a74048ba4550ba6202cb55";
          hash = "sha256-Di3ZZZ4UqR00ud6MdrnJGUngdd/RSC1uNKlsmTdUx2k=";
          leaveDotGit = true;
          postFetch = ''
            pushd $out
              patch -p1 ${./patches/redlib-fix-403.patch}
              rm -rf .git
            popd
          '';
        };
        cargoDeps = pkgsUnstable.rustPlatform.fetchCargoVendor {
          inherit src;
          hash = "sha256-VLXRnSICpMOj/4ebhNSwWH9cwAGTz44kQW6Fa02nwIs=";
        };
        checkFlags = oldAttrs.checkFlags ++ [
          "--skip=test_generic_web_backend"
          "--skip=test_mobile_spoof_backend"
        ];
      });
    })
  ];
}
