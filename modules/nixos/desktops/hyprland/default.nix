{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.custom.desktops.hyprland;
in
{
  options.custom.desktops.hyprland = {
    cache = lib.mkEnableOption "the Hyprland cache";
    enable = lib.mkEnableOption "the Hyprland dynamic tiling compositor";
    enableGreeter = lib.mkEnableOption "the Hyprland login manager";
  };

  config = {
    custom.desktops.hyprland.cache = lib.mkDefault cfg.enable;
    custom.desktops.hyprland.enableGreeter = lib.mkDefault (
      cfg.enable && !config.custom.desktops.gnome.enableGreeter
    );

    programs.hyprland = {
      enable = lib.mkDefault cfg.enable;
      # package = inputs'.hyprland.packages.hyprland;
    };

    services.displayManager.sddm.enable = cfg.enableGreeter;
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

      pamixer
      psmisc
      waybar

      awww

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
