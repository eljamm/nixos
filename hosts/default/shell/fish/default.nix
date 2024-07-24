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
      ns = "nh search $argv | $PAGER";
      nxs = "nix search nixpkgs $argv";
      nxss = "nix search nixpkgs#$argv";
      nxsu = "nix search github:NixOS/nixpkgs/nixos-unstable $argv";
    };
    plugins = [
      {
        name = "fzf";
        inherit (pkgs.fishPlugins.fzf-fish) src;
      }
      {
        name = "fish-async-prompt";
        src = pkgs.fetchFromGitHub {
          owner = "acomagu";
          repo = "fish-async-prompt";
          rev = "316aa03c875b58e7c7f7d3bc9a78175aa47dbaa8";
          hash = "sha256-J7y3BjqwuEH4zDQe4cWylLn+Vn2Q5pv0XwOSPwhw/Z0=";
        };
      }
    ];
  };

  # For fzf.fish
  programs.bat = {
    enable = true;
    extraPackages = with pkgs.bat-extras; [
      batdiff
      batman
      batgrep
      batwatch
    ];
    catppuccin.enable = true;
  };
}
