{ inputs, ... }:
{
  imports = [
    inputs.treefmt-nix.flakeModule
    inputs.git-hooks-nix.flakeModule
  ];

  perSystem =
    { pkgs, ... }:
    {
      formatter = pkgs.nixfmt-rfc-style;

      # Auto-formatters
      # See https://nixos.asia/en/treefmt
      treefmt.config = {
        projectRootFile = "flake.nix";
        programs = {
          nixfmt.enable = true;
        };
      };

      pre-commit.check.enable = true;
      pre-commit.settings.hooks.treefmt.enable = true;
    };
}
