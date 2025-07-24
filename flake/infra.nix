{ self, inputs, ... }:
{
  perSystem =
    {
      system,
      ...
    }:
    {
      _module.args = {
        pkgs = import inputs.nixpkgs {
          config.allowUnfree = true;
          inherit system;
        };
      };
    };
}
