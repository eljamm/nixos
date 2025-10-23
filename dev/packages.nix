{
  pkgs,
  pkgsUnstable,
  ...
}@args:
{
  linux_xanmod_custom = pkgs.linux_xanmod_latest.override {
    argsOverride = rec {
      version = "6.17.4";
      modDirVersion = "${version}-xanmod1";

      src = pkgs.fetchFromGitLab {
        owner = "xanmod";
        repo = "linux";
        rev = modDirVersion;
        hash = "sha256-UHfZwK0qIVhiKw8OpE8i+V2BRav6Fsju8E5rO5WRwVA=";
      };
    };
  };
  inherit (pkgsUnstable)
    drawio
    pgsrip
    whisper-ctranslate2
    ;
}
