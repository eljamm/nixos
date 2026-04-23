{
  inputs,
  pkgsUnstable,
  pkgs,
  lib,
  ...
}:
{
  programs.fish = {
    enable = true;
    shellInit = lib.readFile ./init.fish;
    package = pkgsUnstable.fish;
    functions = {
      mc = "mkdir $argv[1] && cd $argv[1]";

      # Nix
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
        name = "bass";
        inherit (pkgs.fishPlugins.bass) src;
      }
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
    interactiveShellInit = ''
      source ${inputs.gowt.gwt.fishWrapper}
      alias wt="gwt"
      alias ww="gwt jump"
      alias wa="gwt add"
      alias wr="gwt remove"
      alias wk="gwt root"
      alias wh="gwt home"
    '';
  };

  # for `fzf.fish`
  programs.bat = {
    enable = true;
    extraPackages = with pkgs.bat-extras; [
      batman
      batgrep
      batwatch
    ];
  };
}
