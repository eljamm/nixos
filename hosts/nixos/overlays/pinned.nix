{ pkgs, lib, ... }:

{
  nixpkgs.overlays = [
    (final: prev: {
      albert = prev.albert.overrideAttrs rec {
        version = "0.26.10";
        src = final.fetchFromGitHub {
          owner = "albertlauncher";
          repo = "albert";
          rev = "v${version}";
          hash = "sha256-GVYRcrSXz4EXb3isoUN3x/68CAfr0wMgnvv+CzW/yZY=";
          fetchSubmodules = true;
        };
      };
    })
    (final: prev: {
      kitty = prev.kitty.overrideAttrs (oldAttrs: {
        patches = (oldAttrs.patches or [ ]) ++ [
          # Make kitty not freeze when using PaperWM with multi-monitors
          # https://github.com/kovidgoyal/kitty/issues/3069
          ./pkgs/kitty/0002-revert-Wayland-suspend.patch
        ];
      });
    })
    (final: prev: {
      nixpkgs-review = prev.nixpkgs-review.overrideAttrs rec {
        version = "3.0.0";
        src = final.fetchFromGitHub {
          owner = "Mic92";
          repo = "nixpkgs-review";
          tag = version;
          hash = "sha256-C2JAlCgH5OCMAZr/Rvi0H7xAwesnkVCJ3kZyyVYaLg4=";
        };
      };
    })
    (final: prev: {
      zizmor = prev.zizmor.overrideAttrs (oldAttrs: rec {
        pname = "zizmor";
        version = "0.10.0";
        src = final.fetchFromGitHub {
          owner = "woodruffw";
          repo = "zizmor";
          rev = "refs/tags/v${version}";
          hash = "sha256-fq+J1+CrxFSbCimM8SIshwQciEjRjPcjAmdVKbVV13s=";
        };
        cargoHash = "sha256-OUwl9vBB8jMY40SbOc9YK4yyxvgWQTgQRWw2LN07W08=";
        cargoDeps = final.rustPlatform.fetchCargoTarball {
          inherit pname version src;
          hash = cargoHash;
        };
      });
    })
    (
      final: prev:
      let
        pname = "feishin";
        version = "0.12.1";
        src = final.fetchFromGitHub {
          owner = "jeffvli";
          repo = "feishin";
          rev = "v${version}";
          hash = "sha256-UpNtRZhAqRq/sRVkgg/RbLUWNXvHkAyGhu29zWE6Lk0=";
        };
        releaseAppDeps = pkgs.buildNpmPackage {
          pname = "feishin-release-app";
          inherit version;
          src = "${src}/release/app";
          npmDepsHash = "sha256-KZ4TDf9Nz1/dPWAN/gI3tq0gvzI4BvSR3fawte2n9u0=";
          npmFlags = [ "--ignore-scripts" ];
          dontNpmBuild = true;
          env.ELECTRON_SKIP_BINARY_DOWNLOAD = "1";
        };
        releaseNodeModules = "${releaseAppDeps}/lib/node_modules/feishin/node_modules";
      in
      {
        feishin = prev.feishin.overrideAttrs rec {
          inherit pname version src;
          npmDepsHash = "sha256-0YfydhQZgxjMvZYosuS+rGA+9qzSYTLilQqMqlnR1oQ=";
          npmDeps = final.fetchNpmDeps {
            inherit src;
            name = "${pname}-${version}-npm-deps";
            hash = npmDepsHash;
          };
          preConfigure = ''
            for release_module_path in "${releaseNodeModules}"/*; do
              rm -rf node_modules/"$(basename "$release_module_path")"
              ln -s "$release_module_path" node_modules/
            done
          '';
        };
      }
    )
  ];
}
