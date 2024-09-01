{
  inputs,
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.desktops.hyprland;
in
{
  options.desktops.hyprland = {
    enable = lib.mkEnableOption "Hyprland Dynamic Tiling Compositor";
    cache = lib.mkEnableOption "Hyprland Cache";
  };

  config = {
    desktops.hyprland.cache = lib.mkDefault cfg.enable;

    programs.hyprland = {
      enable = lib.mkDefault cfg.enable;
      # package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    };

    services.displayManager.sddm.enable = !config.desktops.gnome.enableGdm;
    services.displayManager.sddm.wayland.enable = true;

    environment.systemPackages = with pkgs; [
      brightnessctl
      cliphist
      dunst
      grimblast
      overskride
      gammastep

      mako
      libnotify
      jq

      hypr
      hypridle
      hyprlock
      hyprls
      hyprpicker
      wlogout

      bluetuith

      pkgs.hyprlandPlugins.hy3

      pamixer
      psmisc
      waybar

      swww

      # External Monitor
      # ddcutil
      # iio-hyprland
      # wluma
    ];

    nix.settings = lib.mkIf cfg.cache {
      substituters = [ "https://hyprland.cachix.org" ];
      trusted-public-keys = [ "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" ];
    };
  };
}
