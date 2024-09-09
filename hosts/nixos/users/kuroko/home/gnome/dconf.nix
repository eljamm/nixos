{ pkgs, lib, ... }:
{
  home.packages = with pkgs; [
    dconf2nix
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

    # TODO: this is too old, use from extension manager for now
    # gnomeExtensions.paperwm 

    #WIP: figure out how to install latest
    # (
    #   let
    #     sha256 = "sha256-zzfQ33r/R5Z/82qt2il+Eqj9KPuap31aae1TI0LEcuI=";
    #   in
    #   (gnomeExtensions.astra-monitor.overrideAttrs {
    #     src = fetchzip {
    #       url = "https://github.com/AstraExt/astra-monitor/archive/4bd51b701fed01fdfdf21d892bc052e9bf1bcf23.zip";
    #       inherit sha256;
    #       stripRoot = false;
    #     };
    #   }).override
    #     { inherit sha256; }
    # )
  ];

  dconf.settings = with lib.hm.gvariant; {
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
        # "dash-to-panel@jderose9.github.com"
        "fix-focus-on-workspace-switch@hiddn.github.com"
        "memento-mori@paveloom"
        "monitor@astraext.github.io"
        "paperwm@paperwm.github.com"
        # "space-bar@luchrioh"
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
      intellihide-key-toggle = [ "<Super><Alt>z" ];
      intellihide-key-toggle-text = "<Super><Alt>z";
      intellihide-only-secondary = false;
      intellihide-pressure-threshold = 100;
      intellihide-pressure-time = 1000;
      intellihide-show-in-fullscreen = false;
      intellihide-use-pressure = true;
      isolate-monitors = true;
      isolate-workspaces = false;
      leftbox-padding = -1;
      multi-monitors = true;
      panel-anchors = ''
        {"0":"MIDDLE","1":"MIDDLE"}
      '';
      panel-element-positions = ''
        {"0":[{"element":"showAppsButton","visible":true,"position":"stackedBR"},{"element":"activitiesButton","visible":false,"position":"stackedTL"},{"element":"leftBox","visible":true,"position":"stackedTL"},{"element":"taskbar","visible":true,"position":"centerMonitor"},{"element":"centerBox","visible":true,"position":"stackedTL"},{"element":"rightBox","visible":true,"position":"stackedBR"},{"element":"dateMenu","visible":false,"position":"stackedBR"},{"element":"systemMenu","visible":false,"position":"stackedBR"},{"element":"desktopButton","visible":false,"position":"stackedBR"}],"1":[{"element":"showAppsButton","visible":true,"position":"stackedBR"},{"element":"activitiesButton","visible":false,"position":"stackedTL"},{"element":"leftBox","visible":true,"position":"stackedTL"},{"element":"taskbar","visible":true,"position":"centerMonitor"},{"element":"centerBox","visible":true,"position":"stackedTL"},{"element":"rightBox","visible":true,"position":"stackedBR"},{"element":"dateMenu","visible":false,"position":"stackedBR"},{"element":"systemMenu","visible":false,"position":"stackedBR"},{"element":"desktopButton","visible":false,"position":"stackedBR"}]}
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
      primary-monitor = 1;
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

    "org/gnome/shell/extensions/paperwm" = {
      default-focus-mode = 1;
      disable-topbar-styling = true;
      edge-preview-enable = true;
      edge-preview-timeout-continual = false;
      edge-preview-timeout-enable = false;
      gesture-enabled = true;
      maximize-within-tiling = true;
      open-window-position = 0;
      overview-ensure-viewport-animation = 1;
      restore-attach-modal-dialogs = "false";
      restore-edge-tiling = "true";
      restore-workspaces-only-on-primary = "false";
      show-focus-mode-icon = true;
      show-window-position-bar = false;
      show-workspace-indicator = true;
      topbar-mouse-scroll-enable = true;
      winprops = [ ];
    };

    "org/gnome/shell/extensions/paperwm/keybindings" = {
      close-window = [ "<Super>x" ];
      cycle-width = [ "<Super>d" ];
      move-down = [ "<Super><Ctrl>Down" ];
      move-down-workspace = [
        "<Super><Ctrl>Page_Down"
        "<Super><Shift>j"
      ];
      move-left = [
        "<Super><Ctrl>comma"
        "<Super><Shift>comma"
        "<Super><Ctrl>Left"
        "<Super><Shift>h"
      ];
      move-right = [
        "<Super><Ctrl>period"
        "<Super><Shift>period"
        "<Super><Ctrl>Right"
        "<Super><Shift>l"
      ];
      move-up = [ "<Super><Ctrl>Up" ];
      move-up-workspace = [
        "<Super><Ctrl>Page_Up"
        "<Super><Shift>k"
      ];
      switch-down-or-else-workspace = [ "<Super>j" ];
      switch-left-loop = [ "<Super>h" ];
      switch-monitor-above = [ "<Super><Shift>Up" ];
      switch-monitor-below = [ "<Super><Shift>Down" ];
      switch-monitor-left = [
        "<Super><Shift>Left"
        "<Super><Ctrl>h"
      ];
      switch-monitor-right = [
        "<Super><Shift>Right"
        "<Super><Ctrl>l"
      ];
      switch-right-loop = [ "<Super>l" ];
      switch-up-or-else-workspace = [ "<Super>k" ];
    };

    "org/gnome/shell/keybindings" = {
      focus-active-notification = [ "<Shift><Super>n" ];
      switch-to-application-1 = [ ];
      switch-to-application-2 = [ ];
      switch-to-application-3 = [ ];
      switch-to-application-4 = [ ];
      toggle-message-tray = [ "<Super>n" ];
      toggle-quick-settings = [ ];
    };

    "org/gnome/desktop/wm/keybindings" = {
      close = [ "<Super>q" ];
      # minimize = [ "<Super>x" ];
      switch-applications = [ "<Alt>Tab" ];
      switch-applications-backward = [ "<Shift><Alt>Tab" ];
      switch-to-workspace-1 = [ "<Super>1" ];
      switch-to-workspace-2 = [ "<Super>2" ];
      switch-to-workspace-3 = [ "<Super>3" ];
      switch-to-workspace-4 = [ "<Super>4" ];
      switch-to-workspace-5 = [ "<Super>5" ];
      switch-to-workspace-6 = [ "<Super>6" ];
      switch-to-workspace-7 = [ "<Super>7" ];
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
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom7/"
      ];
    };

    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
      binding = "<Super>r";
      command = "albert toggle";
      name = "App Launcher";
    };

    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1" = {
      binding = "<Super>s";
      command = "kitty --single-instance";
      name = "Terminal";
    };

    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2" = {
      binding = "<Shift><Super>u";
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

    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom7" = {
      binding = "<Super>b";
      command = "librewolf";
      name = "Internet Browser";
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
      night-light-temperature = mkUint32 3500;
    };

    "org/gnome/mutter" = {
      edge-tiling = true;
      center-new-windows = true;
      dynamic-workspaces = false;
      experimental-features = [
        "scale-monitor-framebuffer" # fractional scaling
        "variable-refresh-rate"
      ];
    };

    "org/gnome/desktop/session" = {
      idle-delay = mkUint32 900;
    };

    "org/gnome/desktop/screensaver" = {
      lock-enabled = false;
    };

    "org/gnome/desktop/wm/preferences" = {
      num-workspaces = 7;
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
      # TODO: remove in favor of keyd?
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
