{ config, pkgs, ... }:

let
  accent = "blue";
  variant = "macchiato";

  kvantumThemePackage = pkgs.catppuccin-kvantum.override { inherit variant accent; };
  themeName = "catppuccin-${variant}-${accent}";
in
{
  catppuccin.flavor = "macchiato";
  catppuccin.accent = "blue";

  qt = {
    enable = true;
    platformTheme.name = "qtct";
    style.name = "kvantum";
  };

  xdg.configFile = {
    "Kvantum/kvantum.kvconfig".text = ''
      [General]
      theme=${themeName}
    '';

    "Kvantum/${themeName}".source = "${kvantumThemePackage}/share/Kvantum/${themeName}";
  };
}
