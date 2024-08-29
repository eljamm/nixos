{
  inputs,
  lib,
  pkgs,
  ...
}:
{
  # imports = [ inputs.hyprland.homeManagerModules.default ];

  # wayland.windowManager.hyprland = {
  #   enable = true;
  #   package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
  #   plugins = [ inputs.hy3.packages.x86_64-linux.hy3 ];
  # };

  wayland.windowManager.hyprland = {
    enable = false;
    settings = pkgs.callPackage ./config.nix;
    plugins = with pkgs.hyprlandPlugins; [ hy3 ];
  };
}
