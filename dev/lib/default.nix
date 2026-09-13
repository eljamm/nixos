{
  lib,
  ...
}:
lib.makeExtensible (self: {
  /*
    Convert a path into a tree-like attribute set.

    :::{.example}
    Suppose we have the following filesystem structure, where every file contains a NixOS module:

    ```
    modules/hardware
    ├── chaotic
    │   ├── kernel.nix
    │   └── mesa.nix
    ├── default.nix
    └── graphics
        ├── amd.nix
        ├── default.nix
        ├── nouveau.nix
        └── nvidia.nix
    ```

    ```nix
    mkModules ./modules/hardware
    {
      chaotic = {
        kernel = «lambda @ <ROOT_PATH>/modules/hardware/chaotic/kernel.nix:1:1»;
        mesa = «lambda @ <ROOT_PATH>/modules/hardware/chaotic/mesa.nix:1:1»;
      };
      default = «lambda @ <ROOT_PATH>/modules/hardware/default.nix:1:1»;
      graphics = {
        amd = «lambda @ <ROOT_PATH>/modules/hardware/graphics/amd.nix:1:1»;
        default = «lambda @ <ROOT_PATH>/modules/hardware/graphics/default.nix:1:1»;
        nouveau = «lambda @ <ROOT_PATH>/modules/hardware/graphics/nouveau.nix:1:1»;
        nvidia = «lambda @ <ROOT_PATH>/modules/hardware/graphics/nvidia.nix:1:1»;
      };
    }
    ```

    These modules can then be imported in NixOS configurations:

    ```
    { inputs, ... }:
    let
      hardware-modules = mkModules ./modules/hardware;
    in
    nixos = inputs.nixpkgs.lib.nixosSystem {
      modules = [
        hardware-modules.graphics.default
        hardware-modules.graphics.amd
      ];
    }
    ```
    :::
  */
  mkModules =
    modules-path:
    let
      fs = lib.fileset;
      git-repo = fs.gitTracked ../../.;
    in
    lib.pipe modules-path [
      (fs.fileFilter (file: file.hasExt "nix"))
      (fs.intersection git-repo)
      (fs.toList)
      (map (
        file:
        let
          relative-path = lib.path.removePrefix modules-path file;
          attrs-path = lib.pipe relative-path [
            (lib.removePrefix "./")
            (lib.removeSuffix ".nix")
            (lib.splitString "/")
          ];
        in
        lib.setAttrByPath attrs-path (import file)
      ))
      (lib.foldl lib.recursiveUpdate { })
    ];

  /*
    Compares 2 packages and returns `true` if the first is newer than the
    second or the same.

    Reference:
    *  0: same version
    *  1: p1 is newer
    * -1: p1 is older

    https://noogle.dev/f/lib/versions/compareVersions
  */
  isNewerOrSame = p1: p2: (lib.strings.compareVersions p1.version p2.version) != -1;

  /**
    Prefer the newest version of a package, compared to a package set.

    This is useful when using overlays, and you want to ensure that the package is always up-to-date, without having to manually modify the overlay.

    # Inputs

    `packageSet`
    : package set to compare against

    `package`
    : derivation to examine

    # Type

    ```
    newestPackage :: AttrSet :: Derivation -> Derivation
    ```
  */
  newestPackage =
    packageSet: package:
    let
      setPackage = packageSet.${package.pname};
    in
    if self.isNewerOrSame setPackage package then setPackage else package;

  # Pick newest derivation from a list of packages.
  newestFromList =
    packageList:
    lib.pipe packageList [
      (lib.sort self.isNewerOrSame)
      (lib.head) # first result == newest
    ];

  # Try evaluating x, else return default
  tryElse =
    x: def:
    let
      res = builtins.tryEval x;
    in
    if res.success then res.value else def;

  # Modified version of Nixpkgs' `makeScope`
  simpleScope = import ./simple-scope.nix { inherit lib; };
})
