{
  self,
  inputs,
  withSystem,
  ...
}:
{
  flake = withSystem "x86_64-linux" (
    ctx@{ inputs', ... }:
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
          pkgsCustom = inputs'.nixpkgs-custom.packages;
          pkgsUnstable = inputs'.nixpkgs-unstable.legacyPackages;
        };

      commonModules = [
        inputs.catppuccin.homeManagerModules.catppuccin
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

      nixosModules.home-navi =
        { pkgs, lib, ... }:
        {
          imports = [ inputs.home-manager.nixosModules.home-manager ];

          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            extraSpecialArgs = args { username = "navi"; };
            users.navi.imports = commonModules ++ [
              ../hosts/navi/home
            ];
          };
        };

      homeConfigurations.kuroko = inputs.home-manager.lib.homeManagerConfiguration {
        pkgs = inputs'.nixpkgs.legacyPackages;
        modules = kuroModules;
        extraSpecialArgs = args;
      };
    }
  );
}
