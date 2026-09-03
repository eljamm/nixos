{
  inputs,
  default,
}:
let
  flakeLib = inputs.flake-utils.lib;
in
{
  # depends on the system (e.g. packages.x86_64-linux)
  perSystem = with default; {
    devShells = devShells;
    formatter = formatter.package;
    packages = lib.filterAttrs (_: v: lib.isDerivation v) packages;
    checks = flakeLib.filterPackages system flake.perSystem.packages;
    legacyPackages = {
      lib = devLib;
      packages = flake.perSystem.packages;
      inherit (default) scripts;
    };
  };

  # system-independant (e.g. nixosModules)
  systemAgnostic = with default; {
    overlays = overlays;

    formatterModule = formatter.module;
    hardwareModules = modules.hardware;
    homeModules = modules.home-manager;
    nixosModules = modules.nixos;

    nixosConfigurations = hosts;
  };
}
