{
  lib,
  ...
}:
{
  imports = [ ./packages.nix ];

  options = {
    currentUser = lib.mkOption {
      description = "Username";
      type = lib.types.str;
      default = null;
    };
  };

  config = {
    currentUser = "kuroko";

    users.users.kuroko = {
      isNormalUser = true;
      description = "kuroko";
      extraGroups = [
        "adbusers"
        "audio"
        "gamemode"
        "networkmanager"
        "video"
        "wheel"
      ];
    };
  };
}
