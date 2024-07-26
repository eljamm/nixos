{ pkgs, lib, ... }:

{
  nixpkgs.overlays = [
    # albert launcher
    (_: prev: {
      albert = prev.albert.overrideAttrs rec {
        version = "0.24.3";
        src = prev.fetchFromGitHub {
          owner = "albertlauncher";
          repo = "albert";
          rev = "v${version}";
          hash = "sha256-9vR6G/9FSy1mqZCo19Mf0RuvW63DbnhEzp/h0p6eXqs=";
          fetchSubmodules = true;
        };
      };
    })

    # llama-cpp
    (_: prev: {
      llama-cpp =
        (prev.llama-cpp.overrideAttrs (finalAttrs: {
          version = "3260";
          owner = "ggerganov";
          repo = "llama.cpp";
          rev = "refs/tags/b${finalAttrs.version}";
          hash = "sha256-0KVwSzxfGinpv5KkDCgF2J+1ijDv87PlDrC+ldscP6s=";
          leaveDotGit = true;
          postFetch = ''
            git -C "$out" rev-parse --short HEAD > $out/COMMIT
            find "$out" -name .git -print0 | xargs -0 rm -rf
          '';
        })).override
          { cudaSupport = true; };
    })

    # TODO: freetube (#330099)
    (_: prev: {
      freetube = prev.freetube.overrideAttrs rec {
        pname = "freetube";
        version = "0.21.2";
        src = prev.fetchurl {
          url = "https://github.com/FreeTubeApp/FreeTube/releases/download/v${version}-beta/freetube_${version}_amd64.AppImage";
          hash = "sha256-Mk8qHDiUs2Nd8APMR8q1wZhTtxyzRhBAeXew9ogC3nk=";
        };
        appimageContents = prev.appimageTools.extractType2 { inherit pname version src; };
        installPhase = ''
          runHook preInstall
          mkdir -p $out/bin $out/share/${pname} $out/share/applications $out/share/icons/hicolor/scalable/apps
          cp -a ${appimageContents}/{locales,resources} $out/share/${pname}
          cp -a ${appimageContents}/freetube.desktop $out/share/applications/${pname}.desktop
          cp -a ${appimageContents}/usr/share/icons/hicolor/scalable/freetube.svg $out/share/icons/hicolor/scalable/apps
          substituteInPlace $out/share/applications/${pname}.desktop \
            --replace 'Exec=AppRun' 'Exec=${pname}'
          runHook postInstall
        '';
      };
    })
  ];
}
