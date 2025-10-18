{
  pkgs,
  pkgsUnstable,
  ...
}@args:
{
  linux_xanmod_custom = pkgs.linux_xanmod_latest.override {
    argsOverride = rec {
      version = "6.17.3";
      modDirVersion = "${version}-xanmod1";

      src = pkgs.fetchFromGitLab {
        owner = "xanmod";
        repo = "linux";
        rev = modDirVersion;
        hash = "sha256-VL1SCMB89P0UcCbtPdkjxcCZqQZpnSTlzzf9e8uzkyA=";
      };
    };
  };
  inherit (pkgsUnstable)
    drawio
    pgsrip
    whisper-ctranslate2
    ;
}
