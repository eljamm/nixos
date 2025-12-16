{
  self ? import ./dev/lib/import-flake.nix { src = ./.; },
  inputs ? self.inputs,
  system ? builtins.currentSystem,
  pkgs ? import inputs.nixpkgs {
    config.allowBroken = true;
    overlays = [ ];
    inherit system;
  },
  lib ? import "${inputs.nixpkgs}/lib",
}:
let
  # custom library (helper functions, builders, ...)
  devLib = import ./dev/lib/default.nix { inherit lib; };

  default = devLib.simpleScope pkgs.newScope (d: {
    inherit
      lib
      pkgs
      self
      system
      inputs
      devLib
      flake # (defined below)
      default # final scope
      ;

    pkgsCustom = inputs.nixpkgs-custom.legacyPackages.${system} // {
      agenix = inputs.agenix.packages.${system}.default;
    };

    pkgsUnstable = import inputs.nixpkgs-unstable {
      config.allowUnfree = true;
      overlays = import ./overlays/unstable;
      inherit system;
    };

    formatter = d.import ./dev/formatter.nix { };
    packages = d.import ./dev/packages.nix { };
    devShells.default = pkgs.mkShellNoCC {
      packages = [
        d.formatter.package
      ];
    };

    overlays.default = final: prev: d.packages;

    hosts = d.import ./hosts { };
    modules = d.devLib.mkModules ./modules;
    scripts = (d.import ./modules/nixos/scripts/default.nix { }).debug.scripts;

    # convenience
    jk = d.hosts.joker.pkgs;
    jkc = d.hosts.joker.config;
    nv = d.hosts.navi.pkgs;
    nvc = d.hosts.navi.config;
  });

  flake = default.call ./dev/flake.nix { };

  # return final scope, with computed and non-recursive attributes
  finalScope = default.fix default;
in
finalScope // finalScope.packages // finalScope.scripts
