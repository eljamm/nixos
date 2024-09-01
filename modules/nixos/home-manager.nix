{
  inputs,
  ...
}:
{
  imports = [ inputs.home-manager.nixosModules.home-manager ];

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs.inputs = inputs;
    users.kuroko.imports = [
      ../../hosts/nixos/users/kuroko/home
      inputs.catppuccin.homeManagerModules.catppuccin
    ];
  };
}
