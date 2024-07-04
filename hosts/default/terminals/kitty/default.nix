{ pkgs, ... }:
{
  programs.kitty = {
    enable = true;
    extraConfig = builtins.readFile ./kitty.conf;
    catppuccin.enable = true;
  };
}
