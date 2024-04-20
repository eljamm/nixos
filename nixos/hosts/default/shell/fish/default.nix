{ pkgs, lib, ... }:
with builtins;
let
  initFile = readFile (./init.fish);
in

{

  programs.fish = {
    enable = true;
    shellInit = initFile;
  };

}
