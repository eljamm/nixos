{
  self,
  pkgs,
  inputs,
  system,
  pkgsCustom,
  pkgsUnstable,
  ...
}:
let
  devArgs = {
    inherit
      self
      inputs
      system
      pkgsCustom
      pkgsUnstable
      ;
  };

  commonModules = [
    inputs.catppuccin.homeModules.catppuccin
    self.homeModules.programs.git
    self.homeModules.programs.neovim.default
    self.homeModules.programs.yazi.default
    self.homeModules.shells.default
    self.homeModules.style.catppuccin
  ];

  kuroModules = commonModules ++ [
    self.homeModules.desktops.gnome.default
    self.homeModules.desktops.hyprland.default
    self.homeModules.terminals.default
    ../../../hosts/nixos/users/kuroko/home
  ];
in
{
  imports = [ inputs.home-manager.nixosModules.home-manager ];
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = devArgs;
    users.kuroko.imports = kuroModules;
  };
}
