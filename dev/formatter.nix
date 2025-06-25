{
  lib,
  pkgs,
  inputs,
  system,
  ...
}@args:
let
  treefmt-nix = import inputs.treefmt-nix;

  treefmt = treefmt-nix.mkWrapper pkgs {
    projectRootFile = "default.nix";
    programs.nixfmt.enable = true;
    programs.actionlint.enable = true;
  };

  pre-commit-hook = inputs.git-hooks-nix.lib.${system}.run {
    src = ../.;
    hooks = {
      treefmt = {
        enable = true;
        package = treefmt;
      };
    };
  };

  formatter = pkgs.writeShellApplication {
    name = "format";
    runtimeInputs = [ treefmt ];
    text = ''
      # shellcheck disable=all
      shell-hook () {
        ${pre-commit-hook.shellHook}
      }

      if [[ -d .git ]]; then
        shell-hook
      fi
      treefmt
    '';
  };
in
formatter
