{ config, username, ... }:
{
  home = {
    username = username;
    homeDirectory = "/home/${username}";

    # WARN:
    # This value determines the Home Manager release that your configuration is
    # compatible with. This helps avoid breakage when a new Home Manager release
    # introduces backwards incompatible changes.
    # ---
    # You should not change this value, even if you update Home Manager. If you do
    # want to update the value, then make sure to first check the Home Manager
    # release notes.
    stateVersion = "23.11"; # Please read the comment before changing.
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  programs.zoxide = {
    enable = true;
    options = [ "--cmd cd" ];
  };

  programs.fzf.enable = true;
  programs.starship.enable = true;
  programs.yazi.enable = true;
  programs.zellij.enable = true;
}
