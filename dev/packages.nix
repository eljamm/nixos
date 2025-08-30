{
  pkgs,
  pkgsUnstable,
  ...
}@args:
{
  linux_xanmod_custom = pkgs.linux_xanmod.override {
    argsOverride = rec {
      version = "6.16.4";
      modDirVersion = "${version}-xanmod1";

      src = pkgs.fetchFromGitLab {
        owner = "xanmod";
        repo = "linux";
        rev = modDirVersion;
        hash = "sha256-CWsGKAID9j24H5oDqlKPToKzl+1Y43F2DmGkc7b2YIg=";
      };
    };
  };
  inherit (pkgsUnstable)
    whisper-ctranslate2
    dl-librescore
    ;
}
