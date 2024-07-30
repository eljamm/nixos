{ pkgs, lib, ... }:
{
  programs.wezterm = {
    enable = true;
    extraConfig = lib.readFile ./wezterm.lua;
  };
}
