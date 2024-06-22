{ pkgs, lib, ... }:
with builtins;
with lib.hm.gvariant;
{
  home.packages = with pkgs; [
    gnomeExtensions.appindicator
    gnomeExtensions.bluetooth-battery-meter
    gnomeExtensions.dash-to-panel
    gnomeExtensions.memento-mori
    gnomeExtensions.pop-shell
    gnomeExtensions.space-bar
    gnomeExtensions.tophat
    gnomeExtensions.user-themes
    gnomeExtensions.vertical-workspaces
    gnomeExtensions.vitals
  ];

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      clock-format = "12h";
      clock-show-weekday = true;
      color-scheme = "prefer-dark";
      enable-hot-corners = true;
    };

    "org/gnome/shell" = {
      disable-user-extensions = false;

      # from `gnome-extensions list`
      enabled-extensions = [
        "Bluetooth-Battery-Meter@maniacx.github.com"
        "appindicatorsupport@rgcjonas.gmail.com"
        "dash-to-panel@jderose9.github.com"
        "memento-mori@paveloom"
        "pop-shell@system76.com"
        "space-bar@luchrioh"
        "tophat@fflewddur.github.io"
        "user-theme@gnome-shell-extensions.gcampax.github.com"
        "vertical-workspaces@G-dH.github.com"
      ];

      favorite-apps = [
        "org.gnome.Settings.desktop"
        "librewolf.desktop"
        "brave-browser.desktop"
        "pcmanfm-qt.desktop"
        "freetube.desktop"
        "kitty.desktop"
        "org.wezfurlong.wezterm.desktop"
        "qps.desktop"
      ];
    };

    "org/gnome/shell/extensions/dash-to-panel" = {
      animate-appicon-hover = false;
      animate-appicon-hover-animation-extent = ''
        {'RIPPLE': 4, 'PLANK': 4, 'SIMPLE': 1}
      '';
      animate-appicon-hover-animation-type = "PLANK";
      appicon-margin = 8;
      appicon-padding = 4;
      available-monitors = [ 0 ];
      dot-color-dominant = true;
      dot-color-override = false;
      dot-position = "BOTTOM";
      dot-style-focused = "DASHES";
      dot-style-unfocused = "DASHES";
      focus-highlight-dominant = false;
      hotkeys-overlay-combo = "TEMPORARILY";
      intellihide = true;
      intellihide-animation-time = 200;
      intellihide-behaviour = "ALL_WINDOWS";
      intellihide-close-delay = 400;
      intellihide-enable-start-delay = 2000;
      intellihide-hide-from-windows = true;
      intellihide-key-toggle = [ "<Super>i" ];
      intellihide-key-toggle-text = "<Super>i";
      intellihide-only-secondary = false;
      intellihide-pressure-threshold = 100;
      intellihide-pressure-time = 1000;
      intellihide-show-in-fullscreen = false;
      intellihide-use-pressure = true;
      leftbox-padding = -1;
      panel-anchors = ''
        {"0":"MIDDLE"}
      '';
      panel-element-positions = ''
        {"0":[{"element":"showAppsButton","visible":true,"position":"centerMonitor"},{"element":"activitiesButton","visible":false,"position":"stackedTL"},{"element":"leftBox","visible":false,"position":"stackedTL"},{"element":"taskbar","visible":true,"position":"centerMonitor"},{"element":"centerBox","visible":true,"position":"stackedBR"},{"element":"rightBox","visible":false,"position":"stackedBR"},{"element":"dateMenu","visible":false,"position":"stackedBR"},{"element":"systemMenu","visible":false,"position":"stackedBR"},{"element":"desktopButton","visible":true,"position":"stackedBR"}]}
      '';
      panel-lengths = ''
        {"0":100}
      '';
      panel-positions = ''
        {"0":"BOTTOM"}
      '';
      panel-sizes = ''
        {"0":48}
      '';
      primary-monitor = 0;
      show-apps-icon-file = "";
      status-icon-padding = -1;
      stockgs-keep-dash = false;
      stockgs-keep-top-panel = true;
      trans-panel-opacity = 0.5;
      trans-use-custom-gradient = false;
      trans-use-custom-opacity = false;
      tray-padding = -1;
      window-preview-title-position = "TOP";
    };

    "org/gnome/shell/extensions/tophat" = {
      cpu-display = "both";
      cpu-show-cores = false;
      disk-display = "numeric";
      disk-monitor-mode = "activity";
      mem-display = "both";
      network-usage-unit = "bytes";
      position-in-panel = "center";
      refresh-rate = "slow";
    };

    "org/gnome/shell/extensions/vitals" = {
      hide-icons = false;
      hide-zeros = false;
      position-in-panel = 2;
    };

    "org/gnome/shell/extensions/memento-mori" = {
      extension-position = "left";
      extension-index = 2;
    };

    "org/gnome/shell/keybindings" = {
      focus-active-notification = [ "<Shift><Super>n" ];
      switch-to-application-1 = [ ];
      switch-to-application-2 = [ ];
      switch-to-application-3 = [ ];
      switch-to-application-4 = [ ];
      toggle-message-tray = [ "<Super>n" ];
    };

    "org/gnome/desktop/wm/keybindings" = {
      close = [ "<Super>q" ];
      minimize = [ "<Super>c" ];
      switch-applications = [ "<Alt>Tab" ];
      switch-applications-backward = [ "<Shift><Alt>Tab" ];
      switch-to-workspace-1 = [
        "<Super>Home"
        "<Super>1"
      ];
      switch-to-workspace-2 = [ "<Super>2" ];
      switch-to-workspace-3 = [ "<Super>3" ];
      switch-to-workspace-4 = [ "<Super>4" ];
      switch-windows = [ "<Super>Tab" ];
      switch-windows-backward = [ "<Shift><Super>Tab" ];
      toggle-fullscreen = [ "<Alt>F10" ];
      toggle-maximized = [ "<Super>m" ];
    };

    "org/gnome/settings-daemon/plugins/media-keys" = {
      custom-keybindings = [
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/"
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/"
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom3/"
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom4/"
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom5/"
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom6/"
      ];
    };

    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
      binding = "<Super>r";
      command = "albert toggle";
      name = "App Launcher";
    };

    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1" = {
      binding = "<Super>t";
      command = "wezterm";
      name = "Terminal";
    };

    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2" = {
      binding = "<Shift><Super>k";
      command = "keepassxc";
      name = "KeepassXC";
    };

    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom3" = {
      binding = "<Shift><Super>e";
      command = "thunderbird";
      name = "E-mail Client";
    };

    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom4" = {
      binding = "<Shift><Super>p";
      command = "io.github.alainm23.planify";
      name = "Planify";
    };

    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom5" = {
      binding = "<Shift>AudioNext";
      command = "playerctl position 5+";
      name = "Audio Seek Forward";
    };

    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom6" = {
      binding = "<Shift>AudioPrev";
      command = "playerctl position 5-";
      name = "Audio Seek Backwards";
    };

    "org/gnome/settings-daemon/plugins/media-keys/screensaver" = {
      binding = [ "<Shift><Super>l" ];
    };

    "org/gnome/settings-daemon/plugins/power" = {
      sleep-inactive-ac-type = "nothing";
      sleep-inactive-battery-timeout = 1800;
    };

    "org/gnome/settings-daemon/plugins/color" = {
      night-light-enabled = true;
      night-light-temperature = mkUint32 4510;
    };

    "org/gnome/mutter" = {
      edge-tiling = true;
      center-new-windows = true;
    };

    "org/gnome/desktop/session" = {
      idle-delay = mkUint32 900;
    };

    "org/gnome/desktop/screensaver" = {
      lock-enabled = false;
    };

    "org/gnome/desktop/peripherals/keyboard" = {
      numlock-state = true;
    };

    "org/gnome/desktop/peripherals/mouse" = {
      natural-scroll = false;
    };

    "org/gnome/desktop/peripherals/touchpad" = {
      natural-scroll = false;
      tap-to-click = true;
      two-finger-scrolling-enabled = true;
    };

    "org/gnome/desktop/input-sources" = {
      mru-sources = [
        (mkTuple [
          "xkb"
          "de+nodeadkeys"
        ])
      ];
      sources = [
        (mkTuple [
          "xkb"
          "de+nodeadkeys"
        ])
        (mkTuple [
          "xkb"
          "us"
        ])
        (mkTuple [
          "xkb"
          "fr+azerty"
        ])
        (mkTuple [
          "xkb"
          "ara+azerty"
        ])
      ];
      # Make Caps Lock an additional Esc ('Shift+Caps Lock' for regular Caps Lock)
      xkb-options = [
        "terminate:ctrl_alt_bksp"
        "caps:escape_shifted_capslock"
      ];
    };

    "org/gnome/desktop/calendar" = {
      show-weekdate = true;
    };
  };
}
