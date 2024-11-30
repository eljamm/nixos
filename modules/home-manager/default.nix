{ inputs, ... }:
{
  flake.homeModules = {
    desktops-gnome = import ./desktops/gnome;
    desktops-hyprland = import ./desktops/hyprland;
    git = import ./programs/git.nix;
    neovim = import ./programs/neovim;
    shells = import ./shells;
    terminals = import ./terminals;
  };
}
