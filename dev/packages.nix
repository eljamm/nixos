{
  pkgs,
  pkgsUnstable,
  ...
}@args:
{
  linux_xanmod_custom = pkgs.linux_xanmod.override {
    argsOverride = rec {
      version = "6.16.5";
      modDirVersion = "${version}-xanmod1";

      src = pkgs.fetchFromGitLab {
        owner = "xanmod";
        repo = "linux";
        rev = modDirVersion;
        hash = "sha256-XQ1blzX1sR7et0qKu+voKDKefjYLYZwHPFo7RbFYekg=";
      };
    };
  };
  inherit (pkgsUnstable)
    whisper-ctranslate2
    dl-librescore
    ;
}
