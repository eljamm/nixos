{ pkgs, ... }:
let
  mpvScripts = with pkgs.mpvScripts; [
    mpris
    mpvacious
    thumbfast
    sponsorblock
  ];
in
{
  programs.mpv = {
    enable = true;
    scripts = mpvScripts;
  };
}
