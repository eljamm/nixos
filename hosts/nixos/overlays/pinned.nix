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
      nix = config.nix.package;
      nixVersions = pkgsUnstable.nixVersions;
    })
    (final: prev: {
      albert = prev.albert.overrideAttrs (
        finalAttrs: oldAttrs: {
          version = "34.0.10";
          src = final.fetchFromGitHub {
            owner = "albertlauncher";
            repo = "albert";
            tag = "v${finalAttrs.version}";
            hash = "sha256-Ryjv8oLUXxK9iOa4ed1lDEbMM7nRj9I02gVT0JNHonQ=";
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
            version = "0.23.15";
            src = final.fetchFromGitHub {
              owner = "FreeTubeApp";
              repo = "FreeTube";
              tag = "v${finalAttrs.version}-beta";
              hash = "sha256-tYRvR75qbJwt6U4KzT9jrJjO5UznpoALqhUTDkeUlzI=";
            };
            yarnOfflineCache = final.fetchYarnDeps {
              yarnLock = "${finalAttrs.src}/yarn.lock";
              hash = "sha256-sxDlPB3CWbFAm3WZ6AlwuVu/4UFR9Stl3q0wpkUXPPU=";
            };
          }
        )
      );
    })
    (final: prev: {
      readest = devLib.newestPackage pkgsUnstable (
        pkgsUnstable.readest.overrideAttrs (
          finalAttrs: oldAttrs: {
            version = "0.10.4";

            src = final.fetchFromGitHub {
              owner = "readest";
              repo = "readest";
              tag = "v${finalAttrs.version}";
              hash = "sha256-/4UyRzFALujZ98EdXxiVeLH8W+0Mqm09RZ4zEwOVyyk=";
              fetchSubmodules = true;
            };

            pnpmDeps = final.fetchPnpmDeps {
              inherit (finalAttrs) pname version src;
              pnpm = final.pnpm_10;
              fetcherVersion = 3;
              hash = "sha256-7jar0aNXaBfoklGzgvC+1DwsOXgpnOcIcEbIGwWgyfw=";
            };

            cargoDeps = final.rustPlatform.fetchCargoVendor {
              inherit (finalAttrs) src;
              hash = "sha256-rxOjXhXN19w8qAEvELIh0oXuB/N80Dtzmf/i3hjRal0=";
            };

            postPatch = oldAttrs.postPatch + ''
              mkdir -p src-tauri/plugins/tauri-plugin-turso/dist-js
              cp -r ${finalAttrs.passthru.tursoPlugin} src-tauri/plugins/tauri-plugin-turso/dist-js
              jq '.scripts.build = "true"' \
                src-tauri/plugins/tauri-plugin-turso/package.json | \
                sponge src-tauri/plugins/tauri-plugin-turso/package.json
            '';

            preBuild = oldAttrs.preBuild + ''
              pnpm --filter @readest/readest-app build
            '';

            passthru.tursoPluginDeps = final.fetchPnpmDeps {
              pname = "tauri-plugin-turso";
              version = finalAttrs.version;
              src = "${finalAttrs.src}/apps/readest-app/src-tauri/plugins/tauri-plugin-turso";
              pnpm = final.pnpm_10;
              fetcherVersion = 3;
              hash = "sha256-Jf/UaEaLUg/v9ZRInBCEfkDY4d6nwyAIegCMKZe0iAQ=";
            };

            passthru.tursoPlugin = final.stdenv.mkDerivation {
              pname = "tauri-plugin-turso";
              version = finalAttrs.version;
              src = "${finalAttrs.src}/apps/readest-app/src-tauri/plugins/tauri-plugin-turso";

              nativeBuildInputs = with final; [
                pnpm_10
                pnpmConfigHook
                nodejs
              ];

              pnpmDeps = finalAttrs.passthru.tursoPluginDeps;

              buildPhase = ''
                pnpm build
              '';

              installPhase = ''
                cp -r dist-js $out
              '';
            };
          }
        )
      );
    })
    (final: prev: {
      yt-dlp = devLib.newestPackage prev (
        prev.yt-dlp.overrideAttrs (oldAttrs: rec {
          version = "2026.03.17";
          src = final.fetchFromGitHub {
            owner = "yt-dlp";
            repo = "yt-dlp";
            tag = version;
            hash = "sha256-A4LUCuKCjpVAOJ8jNoYaC3mRCiKH0/wtcsle0YfZyTA=";
          };
        })
      );
      python3 = prev.python3.override {
        packageOverrides = pyfinal: pyprev: {
          yt-dlp-ejs = devLib.newestPackage pyprev (
            pyprev.yt-dlp-ejs.overridePythonAttrs (oldAttrs: rec {
              pname = "yt-dlp-ejs";
              version = "0.8.0";
              src = final.fetchFromGitHub {
                owner = "yt-dlp";
                repo = "ejs";
                tag = version;
                hash = "sha256-+tOA9sPk0BGJHFQCoAC8y5Bz3UcjgIPDQ8WDPkRlW5k=";
              };
            })
          );
        };
      };
      python3Packages = final.python3.pkgs;
    })
    (final: prev: {
      linux_xanmod_custom =
        let
          version = "6.19.8";
          hash = "sha256-Ay3tWPDz//Pnaam0EjqvVOM3zxSFTby0YxdWBW1a4es=";
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
      models-dev = prev.models-dev.overrideAttrs (oldAttrs: rec {
        pname = "models-dev";
        version = "0-unstable-2026-01-30";
        src = final.fetchFromGitHub {
          owner = "anomalyco";
          repo = "models.dev";
          rev = "8b2b4b40a1f10a27aa15a4de83a7cee6c2aa9b02";
          hash = "sha256-FtdPmJU3g9KNBDrxbFQR0Tx0cCmlNS48JSD9AUiB+7s=";
        };
        node_modules = oldAttrs.node_modules.overrideAttrs {
          inherit version src;
          outputHash = "sha256-E78Hb4ByMfYL/IZG911dX6XRRKNJ0UbQUWMSv0dclFo=";
        };
      });
    })
    (final: prev: {
      opencode = devLib.pickNewest [
        pkgs.llm-agents.opencode
        pkgsUnstable.opencode
        (pkgsUnstable.opencode.overrideAttrs (oldAttrs: rec {
          version = "1.1.47";
          src = final.fetchFromGitHub {
            owner = "sst";
            repo = "opencode";
            tag = "v${version}";
            hash = "sha256-f6TVxKV9q2yEQ9r9VCTttXLqpOrYdTEKDUJs+MuQJCQ=";
          };
          node_modules = oldAttrs.node_modules.overrideAttrs {
            inherit version src;
            outputHash = "sha256-zkinMkPR1hCBbB5BIuqozQZDpjX4eiFXjM6lpwUx1fM=";
          };
          configurePhase = ''
            runHook preConfigure
            cp -R ${node_modules}/. .
            runHook postConfigure
          '';
        }))
      ];
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
    (final: prev: {
      gwt = inputs.gowt.default;
    })
    inputs.llm-agents.overlays.default
  ];
}
