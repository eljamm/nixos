{
  lib,
  pkgs,
  pkgsUnstable,
  ...
}:
{
  # TODO: investigate why the module options don't work ...
  # files are linked, but the config isn't applied
  programs.yazi = {
    enable = true;
    enableFishIntegration = true;
    package = pkgsUnstable.yazi.override {
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
      extraPackages = with pkgs; [
        mediainfo
      ];
    };
  };
}
