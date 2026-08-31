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
          version = "35.1.0";
          src = final.fetchFromGitHub {
            owner = "albertlauncher";
            repo = "albert";
            tag = "v${finalAttrs.version}";
            hash = "sha256-3YJeZZEm7rnKZhBpKB2pRVNds+xXk18dSbSdSM+hl58=";
            fetchSubmodules = true;
          };
        }
      );
    })
    (final: prev: {
      wox = prev.wox.overrideAttrs (
        finalAttrs: oldAttrs: {
          version = "2.3.0";
          src = final.fetchFromGitHub {
            owner = "Wox-launcher";
            repo = "Wox";
            tag = "v${finalAttrs.version}";
            hash = "sha256-XYPGCHsO5qi5pSTd2M54aAkdMGU0uHaIpZry5+7nuvE=";
          };
          vendorHash = "sha256-gVDOCMBNKY7mJkjUOeO3Y78o/57iftmC4q6tE7Hgcto=";
        }
      );
    })
    (final: prev: {
      freetube = devLib.newestPackage prev (
        prev.freetube.overrideAttrs (
          finalAttrs: _: {
            pname = "freetube";
            version = "0.25.2";
            src = final.fetchFromGitHub {
              owner = "FreeTubeApp";
              repo = "FreeTube";
              tag = "v${finalAttrs.version}-beta";
              hash = "sha256-A25I64GP4FRyP21W5QuVvrWpThyU7hDosO25vkIx0UY=";
            };
            pnpmDeps = final.fetchPnpmDeps {
              inherit (finalAttrs) pname version src;
              pnpm = final.pnpm_10;
              fetcherVersion = 4;
              hash = "sha256-1OnmJi4xCxMALAac4jnLOKg5N/t3pcHgM0AgvF1+DpM=";
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
          version = "2026.08.19";
          src = final.fetchFromGitHub {
            owner = "yt-dlp";
            repo = "yt-dlp";
            tag = version;
            hash = "sha256-BM5ZeGTmHq+1xH6G/zsuCtjLgYgfRA11ya0zIHK5p4g=";
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
          version = "7.1.5";
          hash = "sha256-zELqn/UieXjOBkTNTLi2OCkK4+rpD/IfJEDb7GTTJfk=";
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
      digikam = devLib.newestPackage pkgsUnstable (
        (pkgsUnstable.digikam.overrideAttrs (oldAttrs: {
          version = "9.1.0-unstable-2026-08-30";
          src = final.fetchFromGitLab {
            domain = "invent.kde.org";
            owner = "graphics";
            repo = "digikam";
            rev = "d6d3edd12340cdfa5a7cc5d51a06b616720e2646";
            hash = "sha256-qXec22BkYoE3K+uOS61bT33OdqtfduWhuy8wQhNCrAY=";
          };
          buildInputs = oldAttrs.buildInputs ++ [
            final.opencl-headers
            final.ocl-icd
          ];
        })).override
          {
            enableCuda = true;
          }
      );
    })
    (final: prev: {
      stremio-linux-shell = pkgsUnstable.stremio-linux-shell.overrideAttrs (
        finalAttrs: oldAttrs: {
          version = "1.2.0-unstable-2026-08-03";

          src = final.fetchFromGitHub {
            owner = "Stremio";
            repo = "stremio-linux-shell";
            rev = "c6e7cd22e23ed6401e573fe7fe1a023fc07399a2";
            hash = "sha256-JFG+sUuK+l8Ik00vHPiXJwan0rmMBiY85DnvudYKCsw=";
          };

          cargoDeps = final.rustPlatform.fetchCargoVendor {
            inherit (finalAttrs) src;
            hash = "sha256-FnQ2FN9NtL/YyRmLlyGQApjzV/4uS8OnnY8kbTWTGe8=";
          };

          # unstable version
          doInstallCheck = false;
        }
      );
    })
    (final: prev: {
      gwt = inputs.gowt.default;
    })
    inputs.llm-agents.overlays.shared-nixpkgs
  ];
}
