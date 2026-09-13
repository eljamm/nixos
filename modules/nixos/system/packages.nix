{
  config,
  lib,
  ...
}:

let
  categoryType = lib.types.listOf lib.types.package;
  nestedCategoryType = lib.types.either categoryType (lib.types.attrsOf nestedCategoryType);
in

{
  options.custom.systemPackages = lib.mkOption {
    type = lib.types.submodule {
      freeformType = lib.types.attrsOf categoryType;

      options = {
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
    environment.systemPackages = lib.pipe config.custom.systemPackages [
      lib.attrValues
      lib.flatten
    ];
  };
}
