{ pkgs, lib, ... }:

let
  opentypeFonts = with pkgs; [
    alegreya
    alegreya-sans
    fira-code-symbols
  ];
  truetypeFonts = with pkgs; [
    fira-code
    miracode
    proggyfonts
    (nerdfonts.override {
      fonts = [
        "Hack"
        "FiraCode"
        "DroidSansMono"
        "JetBrainsMono"
        "NerdFontsSymbolsOnly" # for kitty terminal
      ];
    })
  ];
  notoFonts = with pkgs; [
    noto-fonts-cjk
    noto-fonts-color-emoji
  ];

  fonts = opentypeFonts ++ truetypeFonts ++ notoFonts;

  mkFontPath =
    fonts:
    map (font: {
      ".local/share/fonts/nixos/${lib.getName font}" = {
        source = "${font}/share/fonts/";
        recursive = true;
      };
    }) fonts;
in

{
  # Install fonts system-wide
  fonts.packages = opentypeFonts ++ truetypeFonts ++ notoFonts;

  # Link fonts to "~/.local/share/fonts/nixos"
  home-manager.users.kuroko = {
    home.file = lib.mergeAttrsList (mkFontPath fonts);
  };
}
