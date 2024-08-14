{ pkgs, lib, ... }:

let
  opentypeFonts = [ pkgs.fira-code-symbols ];
  truetypeFonts = with pkgs; [
    fira-code
    (nerdfonts.override {
      fonts = [
        "FiraCode"
        "DroidSansMono"
        "JetBrainsMono"
        "NerdFontsSymbolsOnly" # for kitty terminal
      ];
    })
  ];

  # Use correct font path for each type
  fontPath = [
    (mkFontPath opentypeFonts "opentype")
    (mkFontPath truetypeFonts "truetype")
  ];

  mkFontPath =
    fonts: dirname:
    map (font: {
      ".local/share/fonts/nixos/${lib.getName font}" = {
        source = "${font}/share/fonts/${dirname}/";
        recursive = true;
      };
    }) fonts;
in

{
  # Install fonts system-wide
  fonts.packages = opentypeFonts ++ truetypeFonts;

  # Link fonts to "~/.local/share/fonts/nixos"
  home-manager.users.kuroko = {
    home.file = lib.mergeAttrsList (lib.concatLists fontPath);
  };
}
