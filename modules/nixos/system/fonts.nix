{ ... }:
{
  flake.nixosModules = {
    fonts =
      {
        pkgs,
        lib,
        username,
        ...
      }:
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
          nerd-fonts.hack
          nerd-fonts.fira-code
          nerd-fonts.droid-sans-mono
          nerd-fonts.jetbrains-mono
          nerd-fonts.symbols-only # for kitty terminal

          # noto
          noto-fonts
          noto-fonts-cjk-sans
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
        home-manager.users.${username} = {
          home.file = mkFontPaths fonts;
        };
      };
  };
}
