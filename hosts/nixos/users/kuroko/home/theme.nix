{ pkgs, ... }:

let
  variant = "Macchiato";
  accent = "Blue";
  kvantumThemePackage = pkgs.catppuccin-kvantum.override { inherit variant accent; };
in

{
  catppuccin.flavor = "macchiato";

  home.packages = with pkgs; [ libsForQt5.qt5ct ];

  qt = {
    enable = true;
    platformTheme.name = "qtct";
    style.name = "kvantum";
  };

  xdg.configFile = {
    "Kvantum/kvantum.kvconfig".text = ''
      [General]
      theme=Catppuccin-${variant}-${accent}
    '';

    "Kvantum/Catppuccin-${variant}-${accent}".source = "${kvantumThemePackage}/share/Kvantum/Catppuccin-${variant}-${accent}";
  };
}
