{ username, ... }:
{
  imports = [
    ./packages.nix
  ];

  users.users.${username} = {
    isNormalUser = true;
    uid = 1000;
    description = "${username}";
    extraGroups = [
      "adbusers"
      "audio"
      "video"
      "wheel"
    ];
  };
}
