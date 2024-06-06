{ pkgs, ... }:
let
  mpvScripts = with pkgs.mpvScripts; [
    mpris
    mpvacious
    thumbfast
  ];
in
{
  programs.mpv = {
    enable = true;
    scripts = mpvScripts;
  };
}
