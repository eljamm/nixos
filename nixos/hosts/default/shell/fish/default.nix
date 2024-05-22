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
      # List installed packages from specified system
      lspkgs = "nix-store --query --requisites $argv | cut -d- -f2- | sort -u";
      # List installed system packages
      lssys = "nix-store --query --requisites /run/current-system | cut -d- -f2- | sort -u";
      # Nix Search
      ns = "nix search nixpkgs $argv";
      # Nix Search Specific
      nss = "nix search nixpkgs#$argv";
      # Nix Search Unstable
      nsu = "nix search github:NixOS/nixpkgs/nixos-unstable $argv";
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
