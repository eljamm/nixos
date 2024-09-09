{ pkgs, ... }:

{
  nixpkgs.overlays = [
    # TODO: worth following:
    # https://github.com/NixOS/nixpkgs/pull/340427
    # https://github.com/NixOS/nixpkgs/pull/340128
    (_: prev: {
      logseq = prev.logseq.overrideAttrs (
        finalAttrs: oldAttrs: {
          version = "0.10.9";
          src = pkgs.fetchurl {
            url = "https://github.com/logseq/logseq/releases/download/${finalAttrs.version}/logseq-linux-x64-${finalAttrs.version}.AppImage";
            hash = "sha256-XROuY2RlKnGvK1VNvzauHuLJiveXVKrIYPppoz8fCmc=";
            name = "${finalAttrs.pname}-${finalAttrs.version}.AppImage";
          };
          postFixup = ''
            # set the env "LOCAL_GIT_DIRECTORY" for dugite so that we can use the git in nixpkgs
            makeWrapper ${prev.electron}/bin/electron $out/bin/${oldAttrs.pname} \
              --set "LOCAL_GIT_DIRECTORY" ${prev.git} \
              --add-flags $out/share/${oldAttrs.pname}/resources/app \
              --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations}}" \
              --prefix LD_LIBRARY_PATH : "${prev.lib.makeLibraryPath [ prev.stdenv.cc.cc.lib ]}"
          '';
        }
      );
    })

    # https://github.com/NixOS/nixpkgs/pull/338975
    (final: prev: {
      hyprlandPlugins = prev.hyprlandPlugins // {
        hyprscroller = prev.hyprlandPlugins.hyprscroller.overrideAttrs (oldAttrs: {
          version = "0-unstable-2024-09-01";
          src = final.fetchFromGitHub {
            owner = "dawsers";
            repo = "hyprscroller";
            rev = "5fe29fcbd7103782d55cfb50482c64c31189f02a";
            hash = "sha256-Fr2OUEO2LgZsLILnXePuMMbzYBnGA9GyIlLWt2P7bLA=";
          };
        });
      };
    })
  ];
}
