{
  config,
  inputs,
  lib,
  pkgs,
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
        "wireshark"
        "corectrl"
      ];
    };

    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      extraSpecialArgs = {
        inherit inputs;
        pkgsCustom = inputs.nixpkgs-stable.legacyPackages.${pkgs.system};
      };
      users.${config.currentUser}.imports = [
        ./home
        inputs.catppuccin.homeManagerModules.catppuccin
      ];
    };

  };
}
