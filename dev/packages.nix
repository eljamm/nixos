{
  pkgs,
  pkgsUnstable,
  ...
}@args:
{
  linux_xanmod_custom = pkgs.linux_xanmod.override {
    argsOverride = rec {
      version = "6.15.10";
      modDirVersion = "${version}-xanmod1";

      src = pkgs.fetchFromGitLab {
        owner = "xanmod";
        repo = "linux";
        rev = modDirVersion;
        hash = "sha256-6ed820JXJr7QqOX3IiF50SFrYeVrx0xCh73zrlmMy5I=";
      };
    };
  };
  inherit (pkgsUnstable)
    whisper-ctranslate2
    dl-librescore
    ;
}
