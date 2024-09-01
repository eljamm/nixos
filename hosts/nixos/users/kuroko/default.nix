{
  config,
  inputs,
  lib,
  ...
}:
{
  imports = [
    inputs.home-manager.nixosModules.home-manager
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
        "gamemode"
        "networkmanager"
        "video"
        "wheel"
      ];
    };

    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      extraSpecialArgs.inputs = inputs;
      users.${config.currentUser}.imports = [
        ./home
        inputs.catppuccin.homeManagerModules.catppuccin
      ];
    };
  };
}
