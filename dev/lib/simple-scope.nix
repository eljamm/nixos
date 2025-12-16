{
  lib,
}:

finalScope: prevScope:

let
  simpleScope =
    newScope: f:
    let
      self = f self // {
        newScope = scope: newScope (self // scope);
        overrideScope = g: simpleScope newScope (lib.extends g f);
        callPackage = self.newScope { };
        call = self.callPackage;

        # Compute a scope's fixpoint using `callPackage`
        # Example: finalScope = scope.fix scope;
        # See: https://nixos.org/manual/nixpkgs/unstable/#sec-functions-library-fixedPoints
        fix = f;

        # Automatically get arguments from `callPackage`, but don't return an
        # overridable result. Useful for importing files in the top-level.
        import =
          file: args:
          let
            result = self.call file args;
          in
          if lib.isAttrs result then
            removeAttrs result [
              "override"
              "overrideDerivation"
            ]
          else
            # Other results are expected for certain cases (e.g. functions).
            result;
      };
    in
    self;
in
simpleScope finalScope prevScope
