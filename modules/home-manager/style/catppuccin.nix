{ ... }:
{
  catppuccin = {
    enable = true;
    accent = "blue";
    flavor = "macchiato";

    bat.enable = true;
    kitty.enable = true;
    yazi.enable = false; # FIX: https://github.com/catppuccin/nix/issues/577

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
  };
}
