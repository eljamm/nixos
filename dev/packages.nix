{
  pkgs,
  pkgsUnstable,
  ...
}@args:
{
  linux_xanmod_custom = pkgs.linux_xanmod_latest.override {
    argsOverride = rec {
      version = "6.16.6";
      modDirVersion = "${version}-xanmod1";

      src = pkgs.fetchFromGitLab {
        owner = "xanmod";
        repo = "linux";
        rev = modDirVersion;
        hash = "sha256-ayNw64Wkg4HKnxEuvmGmgkJB3wLKqKAkK70mgX3eJJ8=";
      };
    };
  };
  inherit (pkgsUnstable)
    drawio
    pgsrip
    whisper-ctranslate2
    ;
}
