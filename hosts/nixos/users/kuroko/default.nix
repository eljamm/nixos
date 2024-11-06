{
  config,
  lib,
  ...
}:
{
  imports = [
    ./packages.nix
  ];

  options = {
    currentUser = lib.mkOption {
      # TODO: improve
      description = "Username";
      type = lib.types.str;
      default = null;
    };
  };

  config = {
    currentUser = "kuroko";

    users.users.${config.currentUser} = {
      isNormalUser = true;
      description = "${config.currentUser}";
      extraGroups = [
        "adbusers"
        "audio"
        "video"
        "wheel"
      ];
    };
  };
}
