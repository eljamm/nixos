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
      enable = true;
      gnomeShellTheme = false;
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
