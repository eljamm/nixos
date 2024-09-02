{
  inputs,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ./settings.nix
    # inputs.hyprland.homeManagerModules.default
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    # package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    plugins = [
      pkgs.hyprlandPlugins.hy3
      pkgs.hyprlandPlugins.hyprscroller
      # TODO: cleanup
      # inputs.hy3.packages.x86_64-linux.hy3
      # inputs.hyprscroller.packages.x86_64-linux.hyprscroller
    ];
  };

  services.hypridle = {
    enable = true;
    settings = {
      general = {
        after_sleep_cmd = "hyprctl dispatch dpms on";
        ignore_dbus_inhibit = false;
        lock_cmd = "hyprlock";
      };
      listener = [
        # Monitor backlight
        {
          timeout = 300;
          # set backlight to minimum, avoid 0 on OLED monitor
          on-timeout = "brightnessctl -s set 10";
          on-resume = "brightnessctl -r";
        }
        # Keyboard backlight
        {
          timeout = 300;
          on-timeout = "brightnessctl -sd rgb:kbd_backlight set 0 ";
          on-resume = "brightnessctl -rd rgb:kbd_backlight";
        }
        # Screen off after timeout, on when activity is detected
        {
          timeout = 900;
          on-timeout = "hyprctl dispatch dpms off";
          on-resume = "hyprctl dispatch dpms on";
        }
      ];
    };
  };
}
