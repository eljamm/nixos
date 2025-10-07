{
  pkgs,
  pkgsUnstable,
  ...
}@args:
{
  linux_xanmod_custom = pkgs.linux_xanmod_latest.override {
    argsOverride = rec {
      version = "6.16.11";
      modDirVersion = "${version}-xanmod1";

      src = pkgs.fetchFromGitLab {
        owner = "xanmod";
        repo = "linux";
        rev = modDirVersion;
        hash = "sha256-EZjH22q8JvlbFpab4rdrA24kf+r9heneiwy5YM4WfYk=";
      };
    };
  };
  inherit (pkgsUnstable)
    drawio
    pgsrip
    whisper-ctranslate2
    ;
}
