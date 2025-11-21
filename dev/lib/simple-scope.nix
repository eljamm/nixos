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
        call =
          f: args:
          removeAttrs (self.callPackage f args) [
            "override"
            "overrideDerivation"
          ];
        fix = f;
      };
    in
    self;
in
simpleScope newScope prevScope
