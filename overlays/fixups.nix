{ pkgs, ... }:

{
  nixpkgs.overlays = [
    (_: prev: {
      logseq = prev.logseq.overrideAttrs (old: rec {
        version = "0.10.9";
        src = pkgs.fetchurl {
          url = "https://github.com/logseq/logseq/releases/download/${version}/logseq-linux-x64-${version}.AppImage";
          hash = "sha256-XROuY2RlKnGvK1VNvzauHuLJiveXVKrIYPppoz8fCmc=";
          name = "${old.pname}-${version}.AppImage";
        };
        postFixup = ''
              # set the env "LOCAL_GIT_DIRECTORY" for dugite so that we can use the git in nixpkgs
          makeWrapper ${prev.electron}/bin/electron $out/bin/${old.pname} \
              --set "LOCAL_GIT_DIRECTORY" ${prev.git} \
              --add-flags $out/share/${old.pname}/resources/app \
                  --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations}}" \
                  --prefix LD_LIBRARY_PATH : "${prev.lib.makeLibraryPath [ prev.stdenv.cc.cc.lib ]}"
        '';
      });
    })

    # HACK: https://github.com/NixOS/nixpkgs/pull/327462
    # TODO: update and remove
    (_: prev: {
      ntk = prev.ntk.overrideAttrs {
        prePatch = ''
          rm waf
        '';
      };
    })
  ];
}
