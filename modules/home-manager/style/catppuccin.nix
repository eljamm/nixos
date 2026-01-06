{ pkgs, ... }:
{
  catppuccin = {
    enable = true;
    accent = "blue";
    flavor = "macchiato";

    bat.enable = true;
    kitty.enable = true;
    yazi.enable = true;

    fzf = {
      enable = true;
      accent = "red";
    };

    fish.enable = false;
    foot.enable = false;
    mpv.enable = false;
    nvim.enable = false;
    starship.enable = false;
    zellij.enable = false;

    # support v25.12.29
    sources.yazi = pkgs.fetchFromGitHub {
      owner = "catppuccin";
      repo = "yazi";
      rev = "fc69d6472d29b823c4980d23186c9c120a0ad32c";
      hash = "sha256-Og33IGS9pTim6LEH33CO102wpGnPomiperFbqfgrJjw=";
    };
  };
}
