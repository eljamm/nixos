{ lib, ... }:
{
  options.currentUser = lib.mkOption {
    description = "Username";
    type = lib.types.str;
    default = null;
  };
}
