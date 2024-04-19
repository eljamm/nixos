{ pkgs, lib, ... }:
let
  variant = "Macchiato";
  accent = "Blue";
  kvantumThemePackage = pkgs.catppuccin-kvantum.override {
    inherit variant accent;
  };
in
{
  home.packages = with pkgs; [
    papirus-folders
    libsForQt5.qt5ct
  ];

  qt = {
    enable = true;
    platformTheme = "qtct";
    style.name = "kvantum";
  };

  xdg.configFile = {
    "Kvantum/kvantum.kvconfig".text = ''
      [General]
      theme=Catppuccin-${variant}-${accent}
    '';

    "Kvantum/Catppuccin-${variant}-${accent}".source =
      "${kvantumThemePackage}/share/Kvantum/Catppuccin-${variant}-${accent}";
  };
}
