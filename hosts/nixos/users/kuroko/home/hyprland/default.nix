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
