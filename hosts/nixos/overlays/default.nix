{ pkgs, ... }:

{
  imports = [
    ./pinned.nix
    ./fixups.nix
  ];

  # TODO: clean this up
  nixpkgs.overlays = [
    (final: prev: {
      ctranslate2 = prev.ctranslate2.override {
        withCUDA = true;
        withCuDNN = true;
      };
    })
    (final: prev: {
      whisper-ctranslate2 = prev.whisper-ctranslate2.overrideAttrs (
        oldAttrs: finalAttrs: {
          pname = "whisper-ctranslate2";
          version = "0.5.1";
          src = final.fetchFromGitHub {
            owner = "Softcatala";
            repo = "whisper-ctranslate2";
            tag = finalAttrs.version;
            hash = "sha256-y1xCycWUxrLwmnk6tlyag0uN0oo6DRQFeIIBw555VjY=";
          };
        }
      );
    })
    (final: prev: rec {
      python3 = prev.python3.override {
        packageOverrides = finalPython: prevPython: {
          faster-whisper = prevPython.faster-whisper.overrideAttrs (
            oldAttrs: finalAttrs: {
              version = "1.1.0";
              src = final.fetchFromGitHub {
                owner = "SYSTRAN";
                repo = "faster-whisper";
                tag = "v${finalAttrs.version}";
                hash = "sha256-oJBCEwTfon80XQ9XIgnRw0SLvpwX0L5jnezwG0jv3Eg=";
              };
            }
          );
        };
      };
      python3Packages = python3.pkgs;
    })
  ];
}
