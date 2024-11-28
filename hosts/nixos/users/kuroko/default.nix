{
  config,
  lib,
  ...
}:
{
  imports = [
    ./packages.nix
  ];

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
}
