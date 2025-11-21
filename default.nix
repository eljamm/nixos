{
  self ? import ./dev/utils/import-flake.nix { src = ./.; },
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
  simpleScope = import ./dev/utils/simple-scope.nix {
    inherit lib pkgs;
  };

  scope = simpleScope (res: {
    inherit
      lib
      pkgs
      self
      system
      inputs
      flake
      ;

    # Custom library. Contains helper functions, builders, ...
    devLib = res.call ./dev/utils { };

    pkgsCustom = inputs.nixpkgs-custom.legacyPackages.${system} // {
      agenix = inputs.agenix.packages.${system}.default;
    };

    pkgsUnstable = import inputs.nixpkgs-unstable {
      config.allowUnfree = true;
      inherit system;
    };

    formatter = res.call ./dev/formatter.nix { };
    packages = res.call ./dev/packages.nix { };
    devShells.default = pkgs.mkShellNoCC {
      packages = [
        res.formatter.package
      ];
    };

    hosts = res.call ./hosts { };
    modules = res.devLib.mkModules ./modules;

    overlays.default = final: prev: res.devPkgs;
  });

  flake = with scope; {
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
scope
