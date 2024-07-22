{ pkgs, inputs, ... }:

let
  spicetify = inputs.spicetify-nix;
  spicePkgs = spicetify.legacyPackages.${pkgs.system};
in

{
  imports = [ spicetify.nixosModules.default ];

  programs.spicetify = {
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
