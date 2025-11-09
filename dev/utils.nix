{
  lib,
  inputs,
  pkgsUnstable,
  ...
}@args:
{
  # TODO: improve
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
      git-repo = fs.gitTracked ../.;
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
