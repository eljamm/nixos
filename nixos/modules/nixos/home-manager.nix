{ inputs, ... }:

{
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.kuroko.imports = [
      ../../hosts/default/home.nix
      ../../hosts/default/gnome
      ../../hosts/default/neovim
      ../../hosts/default/programs
      ../../hosts/default/shell
      ../../hosts/default/theme.nix
      ../../hosts/default/wezterm
      inputs.catppuccin.homeManagerModules.catppuccin
    ];
    extraSpecialArgs = {
      inherit inputs;
    };
  };
}
