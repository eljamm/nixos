{
  pkgs,
  pkgsUnstable,
  ...
}@args:
{
  linux_xanmod_custom = pkgs.linux_xanmod.override {
    argsOverride = rec {
      version = "6.15.7";
      modDirVersion = "${version}-xanmod1";

      src = pkgs.fetchFromGitLab {
        owner = "xanmod";
        repo = "linux";
        rev = modDirVersion;
        hash = "sha256-YMDjtoGz/PQKmbB2umI+5mODP4A1NqzVusc9kg2zGzA=";
      };
    };
  };
  inherit (pkgsUnstable)
    whisper-ctranslate2
    dl-librescore
    ;
}
