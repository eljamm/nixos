{
  inputs',
  inputs,
  self,
  ...
}:
let
  args =
    {
      username ? "",
    }:
    {
      inherit
        self
        inputs
        inputs'
        username
        ;
      pkgsCustom = inputs'.nixpkgs-stable-system.legacyPackages;
    };

  commonModules = [
    inputs.catppuccin.homeManagerModules.catppuccin
    self.homeModules.git
    self.homeModules.neovim
    self.homeModules.shells
  ];

  kuroModules = commonModules ++ [
    self.homeModules.desktops-gnome
    self.homeModules.desktops-hyprland
    self.homeModules.terminals
    ../hosts/nixos/users/kuroko/home
  ];
in
{
  flake.nixosModules.home-kuroko =
    { pkgs, lib, ... }:
    {
      imports = [
        inputs.home-manager.nixosModules.home-manager
      ];

      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        extraSpecialArgs = args { username = "kuroko"; };
        users.kuroko.imports = kuroModules;
      };
    };
      };
    };

  flake.homeConfigurations.kuroko = inputs.home-manager.lib.homeManagerConfiguration {
    pkgs = inputs'.nixpkgs.legacyPackages;
    modules = kuroModules;
    extraSpecialArgs = args;
  };
}
