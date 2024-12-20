{
  pkgs,
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
      agents = [
        "ssh"
        "gpg"
      ];
    };

    mangohud.enable = true;
    taskwarrior = {
      enable = true;
      package = pkgs.taskwarrior3;
    };

    # File managers
    joshuto.enable = true;
    yazi = {
      enable = true;
      enableFishIntegration = true;
    };

    starship = {
      enable = true;
      # enableInteractive = false; # TODO:
    };

    fzf.enable = true;

    zellij.enable = true;

    go.enable = true;
    zsh.enable = true;
  };
}
