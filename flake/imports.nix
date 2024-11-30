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

    ../modules/nixos/apps
    ../modules/nixos/audio
    ../modules/nixos/development
    ../modules/nixos/services
    ../modules/nixos/services/media.nix
    ../modules/nixos/system/fonts.nix
    ../modules/nixos/system/virtualisation.nix
  ];
}
