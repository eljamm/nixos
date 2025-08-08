{
  pkgs,
  pkgsUnstable,
  ...
}@args:
{
  linux_xanmod_custom = pkgs.linux_xanmod.override {
    argsOverride = rec {
      version = "6.15.9";
      modDirVersion = "${version}-xanmod1";

      src = pkgs.fetchFromGitLab {
        owner = "xanmod";
        repo = "linux";
        rev = modDirVersion;
        hash = "sha256-43SaSDdOfz+aG2T2C9UFbbXYi/7YxbQfTYrKjeEMP+E=";
      };
    };
  };
  inherit (pkgsUnstable)
    whisper-ctranslate2
    dl-librescore
    ;
}
