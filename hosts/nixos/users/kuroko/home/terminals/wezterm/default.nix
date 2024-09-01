{ pkgs, lib, ... }:
{
  programs.wezterm = {
    enable = false;
    extraConfig = lib.readFile ./wezterm.lua;
  };
}
