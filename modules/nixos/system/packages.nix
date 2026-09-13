{
  config,
  lib,
  ...
}:

let
  categoryType = lib.types.listOf lib.types.package;
in

{
  options.custom.systemPackages = lib.mkOption {
    type = lib.types.submodule {
      freeformType = lib.types.attrsOf categoryType;

      options = {
        internet = lib.mkOption {
          type = categoryType;
          default = [ ];
          description = "";
        };
        office = lib.mkOption {
          type = categoryType;
          default = [ ];
          description = "";
        };
        chat = lib.mkOption {
          type = categoryType;
          default = [ ];
          description = "";
        };
        networking = lib.mkOption {
          type = categoryType;
          default = [ ];
          description = "";
        };
        security = lib.mkOption {
          type = categoryType;
          default = [ ];
          description = "";
        };
        system = lib.mkOption {
          type = categoryType;
          default = [ ];
          description = "";
        };
        productivity = lib.mkOption {
          type = categoryType;
          default = [ ];
          description = "";
        };
        tools = lib.mkOption {
          type = categoryType;
          default = [ ];
          description = "";
        };
        media = lib.mkOption {
          type = categoryType;
          default = [ ];
          description = "";
        };
        music = lib.mkOption {
          type = categoryType;
          default = [ ];
          description = "";
        };
        notes = lib.mkOption {
          type = categoryType;
          default = [ ];
          description = "";
        };
        nix = lib.mkOption {
          type = categoryType;
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
