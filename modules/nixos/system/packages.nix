{
  config,
  lib,
  ...
}:

let
  cfg = config.custom.systemPackages;
  categoryType = lib.types.listOf lib.types.package;
  nestedCategoryType = lib.types.either categoryType (lib.types.attrsOf nestedCategoryType);
in

{
  options.custom.systemPackages = lib.mkOption {
    type = lib.types.submodule {
      freeformType = nestedCategoryType;

      options = {
        _all = lib.mkOption {
          internal = true;
          readOnly = true;
          default = lib.pipe cfg [
            (lib.flip lib.removeAttrs [ "_all" ]) # avoid infinite recursion
            (lib.attrsets.collect lib.isList)
            lib.flatten
          ];
          type = lib.types.listOf lib.types.package;
          description = "Collection of all category packages. For debugging.";
        };

        internet = lib.mkOption {
          type = nestedCategoryType;
          default = [ ];
          description = "";
        };
        office = lib.mkOption {
          type = nestedCategoryType;
          default = [ ];
          description = "";
        };
        chat = lib.mkOption {
          type = nestedCategoryType;
          default = [ ];
          description = "";
        };
        networking = lib.mkOption {
          type = nestedCategoryType;
          default = [ ];
          description = "";
        };
        security = lib.mkOption {
          type = nestedCategoryType;
          default = [ ];
          description = "";
        };
        system = lib.mkOption {
          type = nestedCategoryType;
          default = [ ];
          description = "";
        };
        productivity = lib.mkOption {
          type = nestedCategoryType;
          default = [ ];
          description = "";
        };
        development = lib.mkOption {
          type = nestedCategoryType;
          default = [ ];
          description = "";
        };
        tools = lib.mkOption {
          type = nestedCategoryType;
          default = [ ];
          description = "";
        };
        media = lib.mkOption {
          type = nestedCategoryType;
          default = [ ];
          description = "";
        };
        music = lib.mkOption {
          type = nestedCategoryType;
          default = [ ];
          description = "";
        };
        notes = lib.mkOption {
          type = nestedCategoryType;
          default = [ ];
          description = "";
        };
        nix = lib.mkOption {
          type = nestedCategoryType;
          default = [ ];
          description = "";
        };
      };
    };
  };

  config = {
    environment.systemPackages = config.custom.systemPackages._all;
  };
}
