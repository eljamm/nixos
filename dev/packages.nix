{
  lib,
  pkgs,
  pkgsUnstable,
  ...
}@args:
{
  inherit (pkgsUnstable)
    drawio
    pgsrip
    whisper-ctranslate2
    ;
}
