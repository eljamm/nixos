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
  scope = lib.makeScope pkgs.newScope (sc: {
    inherit
      lib
      pkgs
      self
      system
      inputs
      ;

    # Custom library. Contains helper functions, builders, ...
    devLib = sc.callPackage ./dev/utils.nix { };

    pkgsCustom = inputs.nixpkgs-custom.legacyPackages.${system} // {
      agenix = inputs.agenix.packages.${system}.default;
    };

    pkgsUnstable = import inputs.nixpkgs-unstable {
      config.allowUnfree = true;
      inherit system;
    };

    formatter = sc.callPackage ./dev/formatter.nix { };
    devPkgs = lib.filterAttrs (n: v: lib.isDerivation v) (sc.callPackage ./dev/packages.nix { });
    devShells.default = pkgs.mkShellNoCC {
      packages = [
        sc.formatter.package
      ];
    };

    hosts = sc.callPackage ./hosts { };
    modules = sc.devLib.mkModules ./modules;

    overlays.default = final: prev: sc.devPkgs;

    flake.perSystem = {
      devShells = sc.devShells;
      formatter = sc.formatter.package;
      packages = sc.devPkgs;
      checks = lib.filterAttrs (_: v: !v.meta.broken or false) sc.flake.perSystem.packages;
      legacyPackages = {
        lib = sc.devLib;
        packages = sc.devPkgs;
      };
    };
    flake.systemAgnostic = {
      inherit (sc) overlays;

      formatterModule = sc.formatter.module;
      hardwareModules = sc.modules.hardware;
      homeModules = sc.modules.home-manager;
      nixosModules = sc.modules.nixos;

      nixosConfigurations = sc.hosts;
    };
  });
in
scope
