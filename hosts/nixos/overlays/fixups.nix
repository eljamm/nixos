{
  lib,
  config,
  pkgs,
  ...
}:

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
      ctranslate2 = prev.ctranslate2.override {
        withCUDA = true;
        withCuDNN = true;
      };
    })
    (final: prev: {
      aseprite = prev.aseprite.override {
        clangStdenv = final.ccacheStdenv.override { stdenv = final.clangStdenv; };
      };
    })
    # TODO: remove after https://github.com/NixOS/nixpkgs/pull/441512
    (final: prev: {
      crow-translate = final.callPackage ./pkgs/crow.nix { };
    })
    (final: prev: {
      swt = prev.swt.overrideAttrs (oldAttrs: {
        env.NIX_CFLAGS_COMPILE = toString [
          "-Wno-error=deprecated-declarations"
        ];
      });
    })
  ];

  # https://github.com/NixOS/nixpkgs/pull/460330
  # TODO: remove when switching to 25.11
  environment.etc."fish/generated_completions".source =
    let
      patchedGenerator = pkgs.stdenv.mkDerivation {
        name = "fish_patched-completion-generator";
        srcs = [
          "${config.programs.fish.package}/share/fish/tools/create_manpage_completions.py"
        ];
        unpackCmd = "cp $curSrc $(basename $curSrc)";
        sourceRoot = ".";
        patches = [ ./patches/fish_completion-generator.patch ]; # to prevent collisions of identical completion files
        dontBuild = true;
        installPhase = ''
          mkdir -p $out
          cp * $out/
        '';
        preferLocalBuild = true;
        allowSubstitutes = false;
      };
      generateCompletions =
        package:
        pkgs.runCommandLocal
          (
            let
              inherit (lib.strings) stringLength substring storeDir;
              storeLength = stringLength storeDir + 34; # Nix' StorePath::HashLen + 2 for the separating slash and dash
              pathName = substring storeLength (stringLength package - storeLength) package;
            in
            (package.name or pathName) + "_fish-completions"
          )
          (
            {
              inherit package;
            }
            // lib.optionalAttrs (package ? meta.priority) { meta.priority = package.meta.priority; }
          )
          ''
            mkdir -p $out
            if [ -d $package/share/man ]; then
              find -L $package/share/man -type f | xargs ${pkgs.python3.pythonOnBuildForHost.interpreter} ${patchedGenerator}/create_manpage_completions.py --directory $out >/dev/null
            fi
          '';
    in
    lib.mkForce (
      pkgs.buildEnv {
        name = "system_fish-completions";
        ignoreCollisions = true;
        paths = builtins.map generateCompletions config.environment.systemPackages;
      }
    );
}
