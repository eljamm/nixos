{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "kuroko";
  home.homeDirectory = "/home/kuroko";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.11"; # Please read the comment before changing.

  # nixpkgs.overlays = [ (
  #   _: final: prev: {
  #     pythonPackagesExtensions = prev.pythonPackagesExtensions ++ [
  #       (
  #         python-final: python-prev: {
  #           catppuccin = python-prev.catppuccin.overridePythonAttrs (oldAttrs: rec {
  #             version = "1.3.2";
  #
  #             src = prev.fetchFromGitHub {
  #               owner = "catppuccin";
  #               repo = "python";
  #               rev = "refs/tags/v${version}";
  #               hash = "sha256-spPZdQ+x3isyeBXZ/J2QE6zNhyHRfyRQGiHreuXzzik=";
  #             };
  #
  #             # can be removed next version
  #             disabledTestPaths = [
  #               "tests/test_flavour.py" # would download a json to check correctness of flavours
  #             ];
  #           });
  #         }
  #       )
  #     ];
  #   }
  # ) ];

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    bat
    moar
    zoxide
    mpv

    ## Gnome
    gnomeExtensions.appindicator
    gnomeExtensions.user-themes
    gnomeExtensions.tray-icons-reloaded
    gnomeExtensions.vitals
    gnomeExtensions.dash-to-panel
    gnomeExtensions.sound-output-device-chooser
    gnomeExtensions.space-bar
    catppuccin-gtk

    ## QT
    libsForQt5.qtstyleplugin-kvantum
    libsForQt5.qt5ct
  ];

  programs.zoxide = {
    enable = true;
  };

  programs.bat = {
    enable = false;

    config = {
      theme = "ansi";
      pager = "less -FR --use-color -Dd+r -Du+b";
      # map-syntax = ["*.jenkinsfile:Groovy" "*.props:Java Properties"];
    };
  };

  gtk = {
    enable = true;
    theme = {
      name = "Catppuccin-Macchiato-Standard-Blue-Dark";
      package = pkgs.catppuccin-gtk.override {
        accents = [ "pink" ];
        size = "compact";
        tweaks = [ "rimless" "black" ];
        variant = "macchiato";
      };
    };
  };

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      enable-hot-corners = true;
    };

    "org/gnome/shell" = {
      disable-user-extensions = false;

      # `gnome-extensions list` for a list
      enabled-extensions = [
        "user-theme@gnome-shell-extensions.gcampax.github.com"
        # "trayIconsReloaded@selfmade.pl"
        "appindicatorsupport@rgcjonas.gmail.com"
        "Vitals@CoreCoding.com"
        "dash-to-panel@jderose9.github.com"
        # "sound-output-device-chooser@kgshank.net"
        "space-bar@luchrioh"
      ];
    };

    "org/gnome/desktop/wm/keybindings" = {
      switch-applications = [ "<Alt>Tab" ];
      switch-applications-backward = [ "<Shift><Alt>Tab" ];
      switch-to-workspace-1 = [ "<Super>Home" "<Super>1" ];
      switch-to-workspace-2 = [ "<Super>2" ];
      switch-to-workspace-3 = [ "<Super>3" ];
      switch-to-workspace-4 = [ "<Super>4" ];
      switch-windows = [ "<Super>Tab" ];
      switch-windows-backward = [ "<Shift><Super>Tab" ];
    };
  };

  xdg.configFile = {
    "gtk-4.0/assets".source = "${config.gtk.theme.package}/share/themes/${config.gtk.theme.name}/gtk-4.0/assets";
    "gtk-4.0/gtk.css".source = "${config.gtk.theme.package}/share/themes/${config.gtk.theme.name}/gtk-4.0/gtk.css";
    "gtk-4.0/gtk-dark.css".source = "${config.gtk.theme.package}/share/themes/${config.gtk.theme.name}/gtk-4.0/gtk-dark.css";
  };

  xdg.configFile."Kvantum/kvantum.kvconfig".source = (pkgs.formats.ini { }).generate "kvantum.kvconfig" {
    General.theme = "Catppuccin-Macchiato-Blue";
  };

  nixpkgs.config.qt = {
    enable = true;
    platformTheme = "qtct";
    style = {
      package = pkgs.catppuccin-kvantum;
      name = "kvantum";
    };
  };

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  home.sessionVariables = {
    MANPAGER = "moar";
    # MANPAGER = "sh -c 'col -x | bat -l man -p'";
  };

  systemd.user.sessionVariables = {
    QT_QPA_PLATFORMTHEME = "qt5ct";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
