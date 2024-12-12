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
  ];
}
