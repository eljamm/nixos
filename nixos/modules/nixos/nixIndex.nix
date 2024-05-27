{ pkgs, lib, ... }:

{
  programs = {
    nix-index-database.comma.enable = true;
    command-not-found.enable = false;
    nix-index = {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
    };
  };
}
