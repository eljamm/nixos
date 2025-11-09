{
  lib,
  pkgs,
  pkgsUnstable,
  ...
}:
{
  programs.yazi = {
    enable = true;
    enableFishIntegration = true;
    package = pkgsUnstable.yazi;
    initLua = ./init.lua;
    settings.keymap = lib.importTOML ./keymap.toml;
    settings.yazi = lib.importTOML ./yazi.toml;
    plugins = {
      inherit (pkgsUnstable.yaziPlugins)
        full-border
        git
        jump-to-char
        mediainfo
        smart-enter
        smart-filter
        smart-paste
        starship
        toggle-pane
        ;
      bookmarks = pkgsUnstable.callPackage ./bookmarks.nix { };
      compress = pkgsUnstable.callPackage ./compress.nix { };
    };
    # TODO: 25.11
    # extraPackages = with pkgs; [
    #   mediainfo
    # ];
  };
}
