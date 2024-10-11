{ pkgs, lib, ... }:

let
  accent = "blue";
  flavor = "macchiato";
  enable = true;
in

{
  home.packages = with pkgs; [ papirus-folders ];

  catppuccin.pointerCursor = {
    accent = "dark";
    inherit enable flavor;
  };

  gtk = {
    enable = true;
    catppuccin = {
      gnomeShellTheme = true;
      inherit enable accent flavor;

      icon = {
        inherit enable accent flavor;
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
