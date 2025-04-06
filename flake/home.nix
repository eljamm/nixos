{
  self,
  inputs,
  withSystem,
  ...
}:
{
  flake = withSystem "x86_64-linux" (
    { inputs', devArgs, ... }:
    let
      commonModules = [
        inputs.catppuccin.homeModules.catppuccin
        self.homeModules.git
        self.homeModules.neovim
        self.homeModules.shells
        self.homeModules.style-catppuccin
      ];

      kuroModules = commonModules ++ [
        self.homeModules.desktops-gnome
        self.homeModules.desktops-hyprland
        self.homeModules.terminals
        ../hosts/nixos/users/kuroko/home
      ];
    in
    {
      nixosModules.home-kuroko =
        { pkgs, lib, ... }:
        {
          imports = [ inputs.home-manager.nixosModules.home-manager ];
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            extraSpecialArgs = devArgs;
            users.kuroko.imports = kuroModules;
          };
        };

      nixosModules.home-navi =
        { pkgs, lib, ... }:
        {
          imports = [ inputs.home-manager.nixosModules.home-manager ];
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            extraSpecialArgs = devArgs;
            users.navi.imports = commonModules ++ [ ../hosts/navi/home ];
          };
        };

      homeConfigurations.kuroko = inputs.home-manager.lib.homeManagerConfiguration {
        pkgs = inputs'.nixpkgs.legacyPackages;
        modules = kuroModules;
        extraSpecialArgs = devArgs;
      };
    }
  );
}
