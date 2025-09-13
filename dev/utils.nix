{
  lib,
  inputs,
  pkgsUnstable,
  ...
}@args:
{
  nixosSystem =
    {
      username,
      modules,
      specialArgs,
      ...
    }:
    inputs.nixpkgs.lib.nixosSystem {
      specialArgs = specialArgs // {
        inherit username;
      };
      inherit modules;
    };

  /**
    Prefer the unstable version of a package, if it's newer.

    This is useful when using overlays, and you want to ensure that the package is always up-to-date, without having to manually modify the overlay.

    # Inputs

    `package`
    : derivation to compare against unstable

    # Type

    ```
    packageOrUnstable :: AttrSet -> AttrSet
    ```
  */
  packageOrUnstable =
    package:
    let
      package-unstable = pkgsUnstable.${package.pname};
      comparison = lib.strings.compareVersions package.version package-unstable.version;
      unstableIsNewer = comparison == -1;
    in
    if unstableIsNewer then package-unstable else package;

}
