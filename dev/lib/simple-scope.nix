{
  lib,
}:

newScope: prevScope:

let
  simpleScope =
    newScope: f:
    let
      self = f self // {
        newScope = scope: newScope (self // scope);
        overrideScope = g: simpleScope newScope (lib.extends g f);
        callPackage = self.newScope { };

        # Compute a scope's fixpoint using `callPackage`
        # Example: finalScope = scope.fix scope;
        # See: https://nixos.org/manual/nixpkgs/unstable/#sec-functions-library-fixedPoints
        fix = f;

        # Automatically get arguments from `callPackage`, but don't return an
        # overridable result. Useful for importing files in the top-level.
        call =
          f: args:
          removeAttrs (self.callPackage f args) [
            "override"
            "overrideDerivation"
          ];
      };
    in
    self;
in
simpleScope newScope prevScope
