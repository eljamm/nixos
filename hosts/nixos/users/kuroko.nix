{
  config,
  lib,
  ...
}:
{
  import = [ ./packages.nix ];

  currentUser = "kuroko";

  users.users."${config.currentUser}" = {
    isNormalUser = true;
    description = "${config.currentUser}";
    extraGroups = [
      "adbusers"
      "audio"
      "gamemode"
      "networkmanager"
      "video"
      "wheel"
    ];
    # TODO: make a module for packages
    packages = lib.pipe config.homePackages [
      (lib.mapAttrsToList (name: value: value))
      lib.flatten
    ];
  };
}
