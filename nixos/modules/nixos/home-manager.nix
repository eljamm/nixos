{ inputs, ... }:

{
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.kuroko.imports = [
      ../../hosts/default/home.nix
      inputs.catppuccin.homeManagerModules.catppuccin
    ];
    extraSpecialArgs = {
      inherit inputs;
    };
  };
}
