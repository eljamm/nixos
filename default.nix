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

  scope = devLib.simpleScope pkgs.newScope (s: {
    inherit
      lib
      pkgs
      self
      system
      inputs
      devLib
      flake # (defined below)
      ;

    pkgsCustom = inputs.nixpkgs-custom.legacyPackages.${system} // {
      agenix = inputs.agenix.packages.${system}.default;
    };

    pkgsUnstable = import inputs.nixpkgs-unstable {
      config.allowUnfree = true;
      overlays = import ./overlays/unstable;
      inherit system;
    };

    formatter = s.call ./dev/formatter.nix { };
    packages = s.call ./dev/packages.nix { };
    devShells.default = pkgs.mkShellNoCC {
      packages = [
        s.formatter.package
      ];
    };

    hosts = s.call ./hosts { };
    modules = s.devLib.mkModules ./modules;
    scripts = (s.call ./modules/nixos/scripts/default.nix { }).debug.scripts;

    overlays.default = final: prev: s.packages;
  });

  flakeLib = inputs.flake-utils.lib;

  flake = {
    # depends on the system (e.g. packages.x86_64-linux)
    perSystem = with scope; {
      devShells = devShells;
      formatter = formatter.package;
      packages = lib.filterAttrs (_: v: lib.isDerivation v) packages;
      checks = flakeLib.filterPackages system flake.perSystem.packages;
      legacyPackages = {
        lib = devLib;
        packages = flake.perSystem.packages;
      };
    };

    # system-independant (e.g. nixosModules)
    systemAgnostic = with scope; {
      overlays = overlays;

      formatterModule = formatter.module;
      hardwareModules = modules.hardware;
      homeModules = modules.home-manager;
      nixosModules = modules.nixos;

      nixosConfigurations = hosts;
    };
  };

  # return final attribute set (non-recursive)
  finalScope = (scope.fix scope) // {
    # but include the original scope
    inherit scope;
  };
in
finalScope // finalScope.packages // finalScope.scripts
