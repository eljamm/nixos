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
      _module.args = {
        pkgs = import inputs.nixpkgs {
          config.allowUnfree = true;
          inherit system;
        };

        devArgs = {
          pkgsCustom = inputs'.nixpkgs-custom.packages // {
            agenix = inputs.agenix.packages.${system}.default;
          };
          pkgsUnstable = import inputs.nixpkgs-unstable {
            config.allowUnfree = true;
            inherit system;
          };

          inherit
            self
            inputs
            inputs'
            ;
        };
      };
    };
}
