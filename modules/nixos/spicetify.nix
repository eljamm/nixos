{ pkgs, inputs, ... }:

{
  programs.spicetify =
    let
      spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.system};
    in
    {
      enable = true;
      theme = spicePkgs.themes.catppuccin;
      colorScheme = "macchiato";

      enabledExtensions = with spicePkgs.extensions; [
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
}
