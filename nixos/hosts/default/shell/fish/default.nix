{ pkgs, ... }:
with builtins;
let
  initFile = readFile (./init.fish);
in

{

  programs.fish = {
    enable = true;
    shellInit = initFile;
    functions = {
      nxs = "nix search nixpkgs $argv";
      nxss = "nix search nixpkgs#$argv";
      nxsu = "nix search github:NixOS/nixpkgs/nixos-unstable $argv";
    };
    plugins = [
      {
        name = "fzf";
        inherit (pkgs.fishPlugins.fzf-fish) src;
      }
    ];
  };

  # For fzf.fish
  programs.bat = {
    enable = true;
    catppuccin.enable = true;
  };
}
