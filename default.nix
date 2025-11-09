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
    config.allowUnfree = true;
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

    # Custom library. Contains helper functions, builders, ...
    devLib = import ./dev/utils.nix args;

    pkgsCustom = inputs.nixpkgs-custom.legacyPackages.${system} // {
      agenix = inputs.agenix.packages.${system}.default;
    };

    pkgsUnstable = import inputs.nixpkgs-unstable {
      config.allowUnfree = true;
      inherit system;
    };

    devShells = default.shells;
  };

  formatter = import ./dev/formatter.nix args;

  default = rec {
    inherit args;

    packages = import ./dev/packages.nix args;

    shells.default = pkgs.mkShellNoCC {
      packages = [
        formatter
      ];
    };

    hosts = self.nixosConfigurations;
    inherit (hosts) joker navi;

    flake.packages = lib.filterAttrs (n: v: lib.isDerivation v) packages;
    flake.devShells = shells;
    flake.formatter = formatter;
    flake.legacyPackages.lib = args.devLib;
  };
in
default // args // default.packages
