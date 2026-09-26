{ pkgs, ... }:
let
  mpvScripts = with pkgs.mpvScripts; [
    mpris
    mpvacious
    thumbfast
    sponsorblock
    uosc
  ];
in
{
  programs.mpv = {
    enable = true;
    scripts = mpvScripts;
  };
}
