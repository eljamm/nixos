{ pkgs, lib, ... }:
{
  programs.wezterm = {
    enable = false; # FIX: broken
    extraConfig = lib.readFile ./wezterm.lua;
  };
}
