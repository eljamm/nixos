{ inputs, ... }:
{
  flake.homeModules = {
    desktops-gnome =
      { ... }:
      {
        imports = [
          ./dconf.nix
          ./theme.nix
        ];
      };
  };
}
