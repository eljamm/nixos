{ pkgs, ... }:

let
  variant = "macchiato";
  accent = "blue";
  kvantumThemePackage = pkgs.catppuccin-kvantum.override { inherit variant accent; };
in
{
  catppuccin.flavor = "macchiato";

  qt = {
    enable = true;
    platformTheme.name = "kvantum";
    style.name = "kvantum";
  };

  home.packages = with pkgs; [
    kdePackages.qt6ct
    libsForQt5.qt5ct
  ];

  xdg.configFile = {
    "Kvantum/kvantum.kvconfig".text = ''
      [General]
      theme=catppuccin-${variant}-${accent}
    '';

    "Kvantum/catppuccin-${variant}-${accent}".source = "${kvantumThemePackage}/share/Kvantum/catppuccin-${variant}-${accent}";
  };
}
