{ self, inputs, ... }:
{
  perSystem =
    {
      pkgs,
      system,
      inputs',
      ...
    }:
    {
      # Custom library. Contains helper functions, builders, ...
      legacyPackages.lib = pkgs.callPackage ../lib.nix { inherit inputs; };

      _module.args = {
        pkgs = import inputs.nixpkgs {
          config.allowUnfree = true;
          inherit system;
        };

        # Flake argument for accessing the custom library more easily:
        # `perSystem = { devLib, ... }:`
        devLib = self.legacyPackages.${system}.lib;

        devArgs = {
          pkgsCustom = inputs'.nixpkgs-custom.packages;
          pkgsUnstable = inputs'.nixpkgs-unstable.legacyPackages;

          inherit
            self
            inputs
            inputs'
            ;
        };
      };
    };
}
