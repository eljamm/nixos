{ pkgs, lib, ... }:

let
  accent = "blue";
  flavor = "macchiato";
in

{
  home.packages = with pkgs; [ papirus-folders ];

  gtk = {
    enable = true;
    catppuccin = {
      enable = true;
      gnomeShellTheme = true;
      inherit accent flavor;

      cursor = {
        enable = true;
        accent = "dark";
        inherit flavor;
      };

      icon = {
        enable = true;
        inherit accent flavor;
      };
    };
    gtk3 = {
      extraConfig.gtk-application-prefer-dark-theme = true;
    };
  };

  home.pointerCursor = lib.mkForce {
    gtk.enable = true;
    x11.enable = true;
    name = "catppuccin-${flavor}-dark-cursors";
    package = pkgs.catppuccin-cursors.macchiatoDark;
    size = 16;
  };
}
