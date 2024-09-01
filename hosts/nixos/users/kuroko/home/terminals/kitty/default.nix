{ pkgs, lib, ... }:
{
  programs.kitty = {
    enable = true;
    extraConfig = lib.readFile ./kitty.conf;
    catppuccin.enable = true;
  };
}
