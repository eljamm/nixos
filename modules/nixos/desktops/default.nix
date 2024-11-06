{ inputs, ... }:
{
  flake.nixosModules = {
    desktops =
      { self, ... }:
      {
        imports = [
          self.nixosModules.desktops-cosmic
          self.nixosModules.desktops-gnome
          self.nixosModules.desktops-hyprland
        ];
      };
  };
}
