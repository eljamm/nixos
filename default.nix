{
  self ? import ./dev/import-flake.nix { src = ./.; },
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
  scope = lib.makeScope pkgs.newScope (s: {
    inherit
      lib
      pkgs
      self
      system
      inputs
      flake
      ;

    # Custom library. Contains helper functions, builders, ...
    devLib = s.callPackage ./dev/utils.nix { };

    pkgsCustom = inputs.nixpkgs-custom.legacyPackages.${system} // {
      agenix = inputs.agenix.packages.${system}.default;
    };

    pkgsUnstable = import inputs.nixpkgs-unstable {
      config.allowUnfree = true;
      inherit system;
    };

    formatter = s.callPackage ./dev/formatter.nix { };
    packages = s.callPackage ./dev/packages.nix { };
    devShells.default = pkgs.mkShellNoCC {
      packages = [
        s.formatter.package
      ];
    };

    hosts = s.callPackage ./hosts { };
    modules = s.devLib.mkModules ./modules;

    overlays.default = final: prev: s.devPkgs;
  });

  # final attribute set (non-recursive)
  finalScope = scope.packages scope;

  flake = with finalScope; {
    # depends on the system (e.g. packages.x86_64-linux)
    perSystem = {
      devShells = devShells;
      formatter = formatter.package;
      packages = lib.filterAttrs (n: v: lib.isDerivation v) packages;
      checks = lib.filterAttrs (_: v: !v.meta.broken or false) flake.perSystem.packages;
      legacyPackages = {
        lib = devLib;
        packages = flake.perSystem.packages;
      };
    };

    # system-independant (e.g. nixosModules)
    systemAgnostic = {
      overlays = overlays;

      formatterModule = formatter.module;
      hardwareModules = modules.hardware;
      homeModules = modules.home-manager;
      nixosModules = modules.nixos;

      nixosConfigurations = hosts;
    };
  };
in
finalScope
