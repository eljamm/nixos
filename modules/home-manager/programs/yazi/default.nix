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
    package = pkgsUnstable.yazi.override {
      extraPackages = with pkgs; [
        mediainfo
        trash-cli
      ];
    };
    plugins = {
      inherit (pkgsUnstable.yaziPlugins)
        full-border
        git
        jump-to-char
        mediainfo
        recycle-bin
        smart-enter
        smart-filter
        smart-paste
        starship
        toggle-pane
        ;
      bookmarks = pkgsUnstable.callPackage ./bookmarks.nix { };
      compress = pkgsUnstable.callPackage ./compress.nix { };
    };
    initLua = ./init.lua;
    keymap = lib.importTOML ./keymap.toml;
    settings = lib.importTOML ./yazi.toml;
  };
}
