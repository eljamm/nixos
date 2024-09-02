{
  lib,
  ...
}:
{
  wayland.windowManager.hyprland.settings = {
    ################
    ### MONITORS ###
    ################

    # See https://wiki.hyprland.org/Configuring/Monitors/
    monitor = [
      "desc:AU Optronics 0x5895, highres@highrr, 0x0, 1"
      "HDMI-A-1, highres@highrr, 1920x0, 1"
      ", preferred, auto, 1"
    ];

    ###################
    ### MY PROGRAMS ###
    ###################

    # See https://wiki.hyprland.org/Configuring/Keywords/
    "$terminal" = "kitty";
    "$fileManager" = "pcmanfm-qt";
    "$menu" = "albert toggle";
    "$browser" = "librewolf";
    "$editor" = "nvim";
    "$colorPicker" = "hyprpicker";

    #################
    ### AUTOSTART ###
    #################

    # Autostart necessary processes (like notifications daemons, status bars, etc.)
    # Or execute your favorite apps at launch like this:
    exec-once = [
      "$terminal"

      "albert"
      "keepassxc"
      "dunst"
      "waybar"
      "hypridle"

      "gammastep"
      "gammastep-indicator"

      "swww-daemon"
      "swww img ~/.config/hypr/assets/gilx-gurantz-cafe-leblanc-counter.jpg"

      "wl-paste --type text --watch cliphist store"
      "wl-paste --type image --watch cliphist store"
    ];

    #############################
    ### ENVIRONMENT VARIABLES ###
    #############################

    # See https://wiki.hyprland.org/Configuring/Environment-variables/
    env = [
      "XCURSOR_SIZE,16"
      "HYPRCURSOR_SIZE,16"

      # Amd:Nvidia
      "AQ_DRM_DEVICES,/dev/dri/card2:/dev/dri/card1"

      # Nvidia
      # "GBM_BACKEND,nvidia-drm"
      # "__GLX_VENDOR_LIBRARY_NAME,nvidia"
      "LIBVA_DRIVER_NAME,nvidia"
      "NVD_BACKEND,direct"

      # QT
      "QT_QPA_PLATFORM,wayland;xcb"
      "QT_QPA_PLATFORMTHEME,qt6ct"
      "QT_WAYLAND_DISABLE_WINDOWDECORATION,1"
      "QT_AUTO_SCREEN_SCALE_FACTOR,1"
      "QT_STYLE_OVERRIDE,kvantum"

      # Toolkit Backend Variables
      "GDK_BACKEND,wayland,x11,*"
      "SDL_VIDEODRIVER,wayland"
      "CLUTTER_BACKEND,wayland"

      # XDG Specifications
      "XDG_CURRENT_DESKTOP,Hyprland"
      "XDG_SESSION_TYPE,wayland"
      "XDG_SESSION_DESKTOP,Hyprland"
    ];

    #####################
    ### LOOK AND FEEL ###
    #####################

    # Refer to https://wiki.hyprland.org/Configuring/Variables/

    # https://wiki.hyprland.org/Configuring/Variables/#general
    general = {
      gaps_in = 5;
      gaps_out = 10;

      border_size = 2;

      # https://wiki.hyprland.org/Configuring/Variables/#variable-types for info about colors
      "col.active_border" = "rgb(8aadf4) rgb(24273A) rgb(24273A) rgb(8aadf4) 45deg";
      "col.inactive_border" = "rgb(24273A) rgb(24273A) rgb(24273A) rgb(27273A) 45deg";

      # Set to true enable resizing windows by clicking and dragging on borders and gaps
      resize_on_border = false;

      # Please see https://wiki.hyprland.org/Configuring/Tearing/ before you turn this on
      allow_tearing = false;

      layout = "dwindle";
    };

    # https://wiki.hyprland.org/Configuring/Variables/#decoration
    decoration = {
      rounding = 10;

      # Change transparency of focused and unfocused windows
      active_opacity = 1.0;
      inactive_opacity = 1.0;

      drop_shadow = true;
      shadow_range = 4;
      shadow_render_power = 3;
      "col.shadow" = "rgba(1a1a1aee)";

      # https://wiki.hyprland.org/Configuring/Variables/#blur
      blur = {
        enabled = false;
        size = 3;
        passes = 3;
        new_optimizations = true;
        vibrancy = 0.1696;
        ignore_opacity = true;
      };
    };

    # https://wiki.hyprland.org/Configuring/Variables/#animations
    animations = {
      enabled = true;

      # Default animations, see https://wiki.hyprland.org/Configuring/Animations/ for more
      bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";
      animation = [
        "windows, 1, 7, myBezier"
        "windowsOut, 1, 7, default, popin 80%"
        "border, 1, 10, default"
        "borderangle, 1, 8, default"
        "fade, 1, 7, default"
        "workspaces, 1, 6, default"
      ];
    };

    # See https://wiki.hyprland.org/Configuring/Dwindle-Layout/ for more
    dwindle = {
      pseudotile = true; # Master switch for pseudotiling. Enabling is bound to mainMod + P in the keybinds section below
      preserve_split = true; # You probably want this
    };

    # See https://wiki.hyprland.org/Configuring/Master-Layout/ for more
    master = {
      new_status = "master";
    };

    # https://wiki.hyprland.org/Configuring/Variables/#misc
    misc = {
      force_default_wallpaper = 0; # Set to 0 or 1 to disable the anime mascot wallpapers
      disable_hyprland_logo = true; # If true disables the random hyprland logo / anime girl background. :(
      focus_on_activate = true;
      vrr = 2;
      vfr = true;
    };

    # render = {
    #   explicit_sync = false;
    # };

    #############
    ### INPUT ###
    #############

    # https://wiki.hyprland.org/Configuring/Variables/#input
    input = {
      kb_layout = "de,us,fr";
      kb_variant = "nodeadkeys,";
      # kb_model =
      kb_options = "grp:win_space_toggle";
      # kb_rules =

      follow_mouse = 1;

      sensitivity = 0; # -1.0 - 1.0, 0 means no modification.

      touchpad = {
        natural_scroll = false;
      };

      numlock_by_default = true;
    };

    # https://wiki.hyprland.org/Configuring/Variables/#gestures
    gestures = {
      workspace_swipe = true;
      workspace_swipe_fingers = 3;
    };

    cursor = {
      no_hardware_cursors = true;
      # allow_dumb_copy = true;
    };

    ####################
    ### KEYBINDINGSS ###
    ####################

    # See https://wiki.hyprland.org/Configuring/Keywords/
    "$mainMod" = "SUPER";

    # Example binds, see https://wiki.hyprland.org/Configuring/Binds/ for more
    bind = [
      "$mainMod, S, exec, $terminal"
      "$mainMod, T, exec, $terminal"
      "$mainMod, I, exec, $browser"

      "$mainMod, Q, exec, ~/.config/hypr/scripts/killactive"
      "$mainMod, D, exec, ~/.config/hypr/scripts/killactive"
      "$mainMod SHIFT, Q, exit,"

      "$mainMod, E, exec, $fileManager"
      "$mainMod, V, togglefloating,"
      "$mainMod, R, exec, $menu"
      # "$mainMod, U, pseudo,"  # dwindle
      "$mainMod, U, togglesplit," # dwindle

      "$mainMod, F, fullscreen"
      "$mainMod, M, fullscreen, 1"

      # Move focus with mainMod + arrow keys
      "$mainMod, h, movefocus, l"
      "$mainMod, l, movefocus, r"
      "$mainMod, k, movefocus, u"
      "$mainMod, j, movefocus, d"

      # Move focus with mainMod + arrow keys
      "$mainMod SHIFT, h, movewindow, l"
      "$mainMod SHIFT, l, movewindow, r"
      "$mainMod SHIFT, k, movewindow, u"
      "$mainMod SHIFT, j, movewindow, d"

      # Switch workspaces with mainMod + [0-9]
      "$mainMod, 1, workspace, 1"
      "$mainMod, 2, workspace, 2"
      "$mainMod, 3, workspace, 3"
      "$mainMod, 4, workspace, 4"
      "$mainMod, 5, workspace, 5"
      "$mainMod, 6, workspace, 6"
      "$mainMod, 7, workspace, 7"
      "$mainMod, 8, workspace, 8"
      "$mainMod, 9, workspace, 9"
      "$mainMod, 0, workspace, 10"

      # Move active window to a workspace with mainMod + SHIFT + [0-9]
      "$mainMod SHIFT, 1, movetoworkspace, 1"
      "$mainMod SHIFT, 2, movetoworkspace, 2"
      "$mainMod SHIFT, 3, movetoworkspace, 3"
      "$mainMod SHIFT, 4, movetoworkspace, 4"
      "$mainMod SHIFT, 5, movetoworkspace, 5"
      "$mainMod SHIFT, 6, movetoworkspace, 6"
      "$mainMod SHIFT, 7, movetoworkspace, 7"
      "$mainMod SHIFT, 8, movetoworkspace, 8"
      "$mainMod SHIFT, 9, movetoworkspace, 9"
      "$mainMod SHIFT, 0, movetoworkspace, 10"

      # Example special workspace (scratchpad)
      # "$mainMod, S, togglespecialworkspace, magic"
      # "$mainMod SHIFT, S, movetoworkspace, special:magic"

      # Scroll through existing workspaces with mainMod + scroll
      "$mainMod, mouse_down, workspace, e+1"
      "$mainMod, mouse_up, workspace, e-1"

      # to switch between windows in a floating workspace
      "ALT, Tab, cyclenext" # change focus to next window
      "ALT, Tab, alterzorder,current,top" # bring it to the top

      "$mainMod, Tab, cyclenext" # change focus to next window
      "$mainMod, Tab, alterzorder,current,top" # bring it to the top

      "ALT SHIFT, Tab, cyclenext, prev" # change focus to previous window
      "ALT SHIFT, Tab, alterzorder,current,top" # bring it to the top

      # bind = $mainMod, Tab, workspace, previous
      "$mainMod, O, focusmonitor, +1"

      "$mainMod Control, l, focusmonitor, +1"
      "$mainMod Control, h, focusmonitor, -1"

      # Volume and Media Control
      ", XF86AudioRaiseVolume, exec, pamixer -i 5"
      ", XF86AudioLowerVolume, exec, pamixer -d 5"
      ", XF86AudioMicMute, exec, pamixer --default-source -m"
      ", XF86AudioMute, exec, pamixer -t"
      ", XF86AudioPlay, exec, playerctl play-pause"
      ", XF86AudioPause, exec, playerctl play-pause"
      ", XF86AudioNext, exec, playerctl next"
      ", XF86AudioPrev, exec, playerctl previous"

      # Screen brightness
      ", XF86MonBrightnessUp, exec, brightnessctl s +5%"
      ", XF86MonBrightnessDown, exec, brightnessctl s 5%-"

      # Screen brightness
      # ", XF86MonBrightnessUp, exec, ~/.config/hypr/scripts/backlight --inc"
      # ", XF86MonBrightnessDown, exec, ~/.config/hypr/scripts/backlight --dec"

      # Waybar
      "Ctrl, Escape, exec, killall -r waybar; waybar"

      # TODO: don't re-execute
      "$mainMod SHIFT, P, exec, $colorPicker | wl-copy" # Also copies to clipboard

      # "$mainMod SHIFT, L, exec, hyprlock"
      "$mainMod SHIFT, ESCAPE, exec, wlogout"

      "ALT SHIFT, L, exec, keepassxc --lock && dunstify 'KeePassXC Databases Locked'"

      # notifications
      "$mainMod, N, exec, ~/.config/hypr/scripts/notifications/status"

      # Language
      "SUPER, SPACE, exec, ~/.config/hypr/scripts/lang"
    ];

    bindm = [
      # Move/resize windows with mainMod + LMB/RMB and dragging
      "$mainMod, mouse:272, movewindow"
      "$mainMod, mouse:273, resizewindow"
    ];

    ##############################
    ### WINDOWS AND WORKSPACES ###
    ##############################

    # See https://wiki.hyprland.org/Configuring/Window-Rules/ for more
    # See https://wiki.hyprland.org/Configuring/Workspace-Rules/ for workspace rules

    windowrulev2 = [
      "workspace 3 silent, class:^(mpv)$"
      "workspace 9 silent, title:(.*)(\[Locked\] - KeePassXC)$"
      "float, title:^(Unlock Database - KeePassXC)$"
      "float, class:^(otpclient)$"

      "float, class:flameshot"
      "float, class:org.gnome.Characters"

      "float, title:^(File Properties)$"
      "float, title:^(Preferences)$"

      "opacity 0.90 0.90,class:^(neovide)$"
      "opacity 0.90 0.90,class:^(kitty)$"
      "tile,class:^(kitty)$"

      "suppressevent maximize, class:.* # You'll probably like this."
    ];
  };
}
