let
  flake-inputs = import (
    fetchTarball "https://github.com/fricklerhandwerk/flake-inputs/tarball/4.1.0"
  );
  inherit (flake-inputs)
    import-flake
    ;
in
{
  self ? import-flake {
    src = ./.;
  },
  inputs ? self.inputs,
  system ? builtins.currentSystem,
  pkgs ? import inputs.nixpkgs {
    config = { };
    overlays = [ ];
    inherit system;
  },
  lib ? import "${inputs.nixpkgs}/lib",
}:
let
  args = {
    inherit
      lib
      pkgs
      self
      system
      inputs
      ;
    inherit (default)
      packages
      ;

    devShells = default.shells;

    pkgsCustom = inputs.nixpkgs-custom.packages // {
      agenix = inputs.agenix.packages.${system}.default;
    };

    pkgsUnstable = import inputs.nixpkgs-unstable {
      config.allowUnfree = true;
      inherit system;
    };
  };

  formatter = import ./dev/formatter.nix args;

  default = rec {
    packages = import ./dev/packages.nix args;

    shells.default = pkgs.mkShellNoCC {
      packages = [
        formatter
      ];
    };

    flake.packages = lib.filterAttrs (n: v: lib.isDerivation v) packages;
    flake.devShells = shells;
    flake.formatter = formatter;
  };
in
default // args
