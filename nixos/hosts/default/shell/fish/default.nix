{ pkgs, lib, ... }:
with builtins;
let
  initFile = readFile (./init.fish);
in

{

  programs.fish = {
    enable = true;
    shellInit = initFile;
    plugins = [
      { name = "fzf"; src = pkgs.fishPlugins.fzf-fish.src; }
    ];
  };

  # For fzf.fish
  programs.bat = {
    enable = true;
    catppuccin.enable = true;
  };

}
