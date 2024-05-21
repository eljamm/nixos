{ pkgs, ... }:
with builtins;
let
  weztermConfig = readFile (./wezterm.lua);
in

{

  programs.wezterm = {
    enable = true;
    extraConfig = weztermConfig;
  };
}
