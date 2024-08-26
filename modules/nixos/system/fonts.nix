{ pkgs, lib, ... }:

let
  fonts = with pkgs; [
    # opentype
    alegreya
    alegreya-sans
    fira-code-symbols

    # truetype
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

    # noto
    noto-fonts-cjk
    noto-fonts-color-emoji
  ];

  mkFontPaths =
    fonts:
    lib.pipe fonts [
      (map (font: {
        ".local/share/fonts/nixos/${lib.getName font}" = {
          source = "${font}/share/fonts/";
          recursive = true;
        };
      }))
      lib.mergeAttrsList
    ];
in

{
  # Install fonts system-wide
  fonts.packages = fonts;

  # Link fonts to "~/.local/share/fonts/nixos"
  home-manager.users.kuroko = {
    home.file = mkFontPaths fonts;
  };
}
