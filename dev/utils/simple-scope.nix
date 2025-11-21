{
  lib,
  pkgs,
}:

prevScope:

let
  # Modified version of Nixpkgs' `makeScope`
  simpleScope =
    newScope: f:
    let
      self = f self // {
        newScope = scope: newScope (self // scope);
        overrideScope = g: simpleScope newScope (lib.extends g f);
        callPackage = self.newScope { };
        call =
          f: args:
          removeAttrs (self.callPackage f args) [
            "override"
            "overrideDerivation"
          ];
        fix = f;
      };
    in
    f self;
in
simpleScope pkgs.newScope prevScope
