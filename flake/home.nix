{
  self,
  inputs,
  withSystem,
  ...
}:
let
  default = import ../. { inherit self system; };
  system = "x86_64-linux";

  devArgs = {
    inherit (default.args)
      self
      inputs
      system
      pkgsCustom
      pkgsUnstable
      ;
  };
in
{
  flake = withSystem system (
    { inputs', ... }:
    let
      commonModules = [
        inputs.catppuccin.homeModules.catppuccin
        self.homeModules.git
        self.homeModules.neovim
        self.homeModules.shells
        self.homeModules.style-catppuccin
        self.homeModules.yazi
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
