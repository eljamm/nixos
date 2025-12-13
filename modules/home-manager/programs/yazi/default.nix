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
        bookmarks
        compress
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
    };
    initLua = ./init.lua;
    keymap = lib.importTOML ./keymap.toml;
    settings = lib.importTOML ./yazi.toml;
  };
}
