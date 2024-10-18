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
    (final: prev: {
      neovim-unwrapped = prev.neovim-unwrapped.overrideAttrs (oldAttrs: {
        patches = oldAttrs.patches ++ [
          # Fix byte index encoding bounds. See:
          # - https://github.com/neovim/neovim/pull/30747
          # - https://github.com/nix-community/nixvim/issues/2390
          (pkgs.fetchpatch {
            name = "fix-lsp-str_byteindex_enc-bounds-checking-30747.patch";
            url = "https://patch-diff.githubusercontent.com/raw/neovim/neovim/pull/30747.patch";
            hash = "sha256-2oNHUQozXKrHvKxt7R07T9YRIIx8W3gt8cVHLm2gYhg=";
          })
        ];
      });
    })
  ];
}
