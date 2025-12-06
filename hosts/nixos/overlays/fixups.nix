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
    (final: prev: {
      swt = prev.swt.overrideAttrs (oldAttrs: {
        env.NIX_CFLAGS_COMPILE = toString [
          "-Wno-error=deprecated-declarations"
        ];
      });
    })
  ];
}
