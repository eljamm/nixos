{ pkgs, inputs, ... }:

{
  config = {
    programs.spicetify = {
      enable = true;
      theme = inputs.spicetify-nix.packages.${pkgs.system}.default.themes.catppuccin;
      colorScheme = "macchiato";

      enabledExtensions = with inputs.spicetify-nix.packages.${pkgs.system}.default.extensions; [
        adblock
        autoSkipVideo
        bookmark
        fullAppDisplay
        hidePodcasts
        keyboardShortcut
        loopyLoop
        popupLyrics
        shuffle # shuffle+ (special characters are sanitized out of ext names)
      ];
    };
  };
}
