{
  self ? import ./dev/import-flake.nix { src = ./.; },
  inputs ? self.inputs,
  system ? builtins.currentSystem,
  pkgs ? import inputs.nixpkgs {
    config = {
      allowBroken = true;
    };
    overlays = [ ];
    inherit system;
  },
  lib ? import "${inputs.nixpkgs}/lib",
}:
let
  scope = lib.makeScope pkgs.newScope (
    self': with self'; {
      inherit
        lib
        pkgs
        self
        system
        inputs
        ;

      # Custom library. Contains helper functions, builders, ...
      devLib = callPackage ./dev/utils.nix { };

      pkgsCustom = inputs.nixpkgs-custom.legacyPackages.${system} // {
        agenix = inputs.agenix.packages.${system}.default;
      };

      pkgsUnstable = import inputs.nixpkgs-unstable {
        config.allowUnfree = true;
        inherit system;
      };

      hosts = callPackage ./hosts { };

      modules = devLib.mkModules ./modules;
      hardwareModules = devLib.mkModules ./modules/hardware;
      nixosModules = devLib.mkModules ./modules/nixos;
      homeModules = devLib.mkModules ./modules/home-manager;

      format = callPackage ./dev/formatter.nix { };
      devPkgs = lib.filterAttrs (n: v: lib.isDerivation v) (callPackage ./dev/packages.nix { });
      devShells.default = pkgs.mkShellNoCC {
        packages = [
          format.formatter
        ];
      };

      overlays.default = final: prev: devPkgs;

      flake.system-agnostic = {
        inherit
          overlays
          homeModules
          nixosModules
          hardwareModules
          ;
        nixosConfigurations = hosts;
      };
      flake.perSystem = {
        devShells = devShells;
        formatter = format.formatter;
        packages = devPkgs;
        checks = lib.filterAttrs (_: v: !v.meta.broken or false) flake.perSystem.packages;
        legacyPackages = {
          lib = devLib;
          packages = devPkgs;
        };
      };
    }
  );
in
scope // scope.devPkgs // scope.hosts
