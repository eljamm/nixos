{ pkgs, ... }:

{
  nixpkgs.overlays = [
    (final: prev: {
      freetube = prev.freetube.overrideAttrs rec {
        pname = "freetube";
        version = "0.22.1";
        src = final.fetchurl {
          url = "https://github.com/FreeTubeApp/FreeTube/releases/download/v${version}-beta/freetube_${version}_amd64.AppImage";
          hash = "sha256-HbU5yRSP5Gk473ZoQL3HD2Bph/U/sq1Dd0eFpxyKc9s=";
        };
        appimageContents = pkgs.appimageTools.extractType2 { inherit pname version src; };
      };
    })
  ];
}
