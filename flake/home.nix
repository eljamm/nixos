{
  inputs',
  inputs,
  self,
  ...
}:
let
  args = {
    inherit self inputs inputs';
    pkgsCustom = inputs'.nixpkgs-stable-system.legacyPackages;
  };

  homeModules = [
    ../hosts/nixos/users/kuroko/home/default.nix
    inputs.catppuccin.homeManagerModules.catppuccin
    self.homeModules.desktops-gnome
    self.homeModules.desktops-hyprland
    self.homeModules.neovim
    self.homeModules.shells
    self.homeModules.terminals
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
        extraSpecialArgs = args;
        users.kuroko.imports = homeModules;
      };
    };

  flake.homeConfigurations.kuroko = inputs.home-manager.lib.homeManagerConfiguration {
    pkgs = inputs'.nixpkgs.legacyPackages;
    modules = homeModules;
    extraSpecialArgs = args;
  };
}
