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
            version = "0.11.17";

            src = final.fetchFromGitHub {
              owner = "readest";
              repo = "readest";
              tag = "v${finalAttrs.version}";
              hash = "sha256-vueP/UGu1G+DnwqJ7GhcYIxIsyTeFGYIiz7Iu0fs3NA=";
              fetchSubmodules = true;
            };

            pnpmDeps = final.fetchPnpmDeps {
              inherit (finalAttrs) pname version src;
              pnpm = final.pnpm_11;
              fetcherVersion = 4;
              hash = "sha256-wtWYdIfqytwn8PNahbQ/WxJuhhH1lbgNshQy6V0vvcA=";
              pnpmInstallFlags = [
                # Increase number of fetch attempts to work around timeout issues on slow
                # networks: "TimeoutError: The operation was aborted due to timeout".
                # See: https://pnpm.io/settings#request-settings
                "--fetch-retries=5"
              ];
            };

            cargoDeps = final.rustPlatform.fetchCargoVendor {
              inherit (finalAttrs) src;
              hash = "sha256-QxsiYl7mG+kS35pcU8/WLQA+f3gepe7qrHelhUzONbY=";
            };
          }
        )
      );
    })
    (final: prev: {
      yt-dlp = devLib.newestPackage prev (
        prev.yt-dlp.overrideAttrs (oldAttrs: rec {
          version = "2026.06.09";
          src = final.fetchFromGitHub {
            owner = "yt-dlp";
            repo = "yt-dlp";
            tag = version;
            hash = "sha256-ykqTDPzKKIWRGSQmw2esCRKyYqDZKXRYDeba888tkDU=";
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
          version = "7.1.4";
          hash = "sha256-jHYReidaX4aufcpTeWxr/Lu0+W9yHL7SpF7mgjDSyxY=";
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
                PREEMPT_VOLUNTARY = lib.mkForce lib.kernel.unset;
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
      godot_4 = final.godotPackages_4_6.godot;
    })
    # TODO: remove when this is propagated back:
    # https://github.com/NixOS/nixpkgs/pull/506080
    (final: prev: {
      tree-sitter = devLib.newestPackage prev (
        prev.tree-sitter.overrideAttrs (
          finalAttrs: oldAttrs: {
            version = "0.26.8";
            src = final.fetchFromGitHub {
              owner = "tree-sitter";
              repo = "tree-sitter";
              tag = "v${finalAttrs.version}";
              hash = "sha256-fcFEfoALrbpBD6rWogxJ7FNVlvDQgswoX9ylRgko+8Q=";
              fetchSubmodules = true;
            };
            cargoDeps = final.rustPlatform.fetchCargoVendor {
              inherit (finalAttrs) src;
              hash = "sha256-9FeWnWWPUWmMF15Psmul8GxGv2JceHWc2WZPmOr81gw=";
            };
            nativeBuildInputs = oldAttrs.nativeBuildInputs or [ ] ++ [
              final.rustPlatform.bindgenHook
            ];
            patches = [ ./patches/tree-sitter_remove-web-interface.patch ];
          }
        )
      );
    })
    (final: prev: {
      krita = pkgsUnstable.krita.overrideAttrs (oldAttrs: {
        env.PYTHONPATH = final.python3Packages.makePythonPath (
          with final.python3Packages;
          [
            # for https://github.com/davi133/brush_sfx
            sounddevice
          ]
        );
        qtWrapperArgs = [
          # required for drawing tablet to work
          "--set QT_QPA_PLATFORM wayland"
        ];
      });
    })
    (final: prev: {
      stremio-linux-shell = prev.stremio-linux-shell.overrideAttrs (
        finalAttrs: oldAttrs: {
          version = "1.0.0-beta.15-unstable-2026-06-24";

          src = final.fetchFromGitHub {
            owner = "Stremio";
            repo = "stremio-linux-shell";
            rev = "01013c25e011d6491507b0afc47ec9ec8c3f9c69";
            hash = "sha256-As6/H5sCQYYNk5EL+EbI6wncIRGw9QHlHlsLx/iLgME=";
          };

          cargoDeps = final.rustPlatform.fetchCargoVendor {
            inherit (finalAttrs) src;
            hash = "sha256-KaB2S3toyoIB7ZGHL4iINXHz0j7EirtMNLUL60VkS7U=";
          };

          patches = [ ];
          postPatch = "";

          buildInputs = oldAttrs.buildInputs ++ [
            final.libadwaita
            final.libepoxy
            final.webkitgtk_6_0
          ];

          # Node.js is required to run `server.js`
          # Add to `gappsWrapperArgs` to avoid two layers of wrapping.
          preFixup = ''
            gappsWrapperArgs+=(
              --prefix LD_LIBRARY_PATH : "${final.addDriverRunpath.driverLink}/lib" \
              --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath [ final.libGL ]}" \
              --prefix PATH : "${lib.makeBinPath [ final.nodejs ]}" \
              --set SERVER_PATH "${placeholder "out"}/share/stremio/server.js"
            )
          '';

          # unstable version
          doInstallCheck = false;
        }
      );
    })
    (final: prev: {
      gwt = inputs.gowt.default;
    })
    inputs.llm-agents.overlays.default
  ];
}
