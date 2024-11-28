{ ... }:
{
  imports = [
    ../modules/hardware/chaotic.nix
    ../modules/hardware/graphics.nix
    ../modules/home-manager
    ../modules/nixos/desktops
    ../modules/nixos/desktops/cosmic
    ../modules/nixos/desktops/gnome
    ../modules/nixos/desktops/hyprland
  ];
}
