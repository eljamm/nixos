{ inputs, ... }:
{
  flake.homeModules = {
    desktops-gnome = import ./desktops/gnome;
    desktops-hyprland = import ./desktops/hyprland;
    neovim = import ./programs/neovim;
    shells = import ./shells;
    terminals = import ./terminals;
  };
}
