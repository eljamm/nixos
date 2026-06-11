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
    shellWrapperName = "yy";
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
        nav-parent-panel
        recycle-bin
        smart-enter
        smart-filter
        smart-paste
        starship
        toggle-pane
        ;
      yafg = pkgsUnstable.callPackage ./yafg.nix { };
    };
    initLua = ./init.lua;
    keymap = lib.importTOML ./keymap.toml;
    settings = lib.importTOML ./yazi.toml;
  };
}
