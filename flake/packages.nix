{
  perSystem =
    { devArgs, ... }:
    {
      packages = {
        fish = devArgs.pkgsCustom.fish;
        umu-launcher = devArgs.pkgsCustom.umu-launcher;
      };
    };
}
