{ pkgs, lib, ... }:

{
  programs.fish = {
    enable = true;
    shellInit = lib.readFile ./init.fish;
    functions = {
      ns = "nh search $argv | $PAGER";
      nxs = "nix search nixpkgs $argv";
      nxss = "nix search nixpkgs#$argv";
      nxsu = "nix search github:NixOS/nixpkgs/nixos-unstable $argv";
    };
    shellAliases = {
      clr = "clear";
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

  # for `fzf.fish`
  programs.bat = {
    enable = true;
    catppuccin.enable = true;
    extraPackages = with pkgs.bat-extras; [
      batdiff
      batman
      batgrep
      batwatch
    ];
  };
}
