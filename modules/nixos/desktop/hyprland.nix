{
  config,
  pkgs,
  lib,
  ...
}:

let
  hyprlandEnabled = config.programs.hyprland.enable;
in

{
  programs.hyprland.enable = lib.mkDefault false;

  environment.systemPackages = with pkgs; [
    brightnessctl
    cliphist
    dunst
    grimblast
    overskride

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
  ];

  nix.settings = lib.mkIf hyprlandEnabled {
    substituters = [ "https://hyprland.cachix.org" ];
    trusted-public-keys = [ "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" ];
  };
}
