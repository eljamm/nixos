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

    ddcutil
    iio-hyprland
    wluma
  ];

  nix.settings = lib.mkIf hyprlandEnabled {
    substituters = [ "https://hyprland.cachix.org" ];
    trusted-public-keys = [ "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" ];
  };

  boot.kernelModules = [
    # "ddcci"
    # "ddcci-backlight"
    "i2c-dev"
  ];

  # boot.extraModulePackages = [ config.boot.kernelPackages.ddcci-driver ];

  # systemd.services.ddcci = {
  #   serviceConfig.Type = "oneshot";
  #   script = ''
  #     echo 'ddcci 0x37' > /sys/bus/i2c/devices/i2c-2/new_device
  #   '';
  # };
}
