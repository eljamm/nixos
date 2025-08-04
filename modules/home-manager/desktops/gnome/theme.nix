{
  config,
  pkgs,
  lib,
  ...
}:
{
  home.packages = with pkgs; [ papirus-folders ];

  catppuccin = {
    gtk = {
      # FIX: find alternative for gtk
      # https://github.com/catppuccin/gtk/issues/262
      # enable = false;
      # gnomeShellTheme = false;
      icon.enable = true;
    };

    cursors = {
      enable = true;
      accent = "dark";
    };
  };

  gtk = {
    enable = true;
    gtk3.extraConfig.gtk-application-prefer-dark-theme = true;
  };

  home.pointerCursor = lib.mkForce {
    gtk.enable = true;
    x11.enable = true;
    name = "catppuccin-${config.catppuccin.flavor}-dark-cursors";
    package = pkgs.catppuccin-cursors.macchiatoDark;
    size = 16;
  };
}
