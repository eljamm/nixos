{
  pkgs,
  pkgsUnstable,
  ...
}:
{
  programs = {
    zoxide = {
      enable = true;
      options = [ "--cmd cd" ];
    };

    keychain = {
      enable = true;
      extraFlags = [
        "--eval"
        "--noask"
        "--quiet"
      ];
      keys = [ ];
    };

    mangohud.enable = true;
    taskwarrior = {
      enable = true;
      package = pkgs.taskwarrior3;
    };

    # File managers
    joshuto.enable = true;

    starship = {
      enable = true;
      enableInteractive = false;
    };

    fzf.enable = true;

    zellij.enable = true;

    go.enable = true;
    zsh.enable = true;
  };
}
