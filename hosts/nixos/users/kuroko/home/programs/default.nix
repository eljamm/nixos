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
      catppuccin.enable = true;
    };

    starship = {
      enable = true;
      # enableInteractive = false; # TODO:
    };

    # TODO: enable with fish
    fzf = {
      enable = true;
      catppuccin = {
        enable = true;
        accent = "red";
      };
    };

    zellij = {
      enable = true;
      # TODO: writes to a config.kdl file?
      # catppuccin.enable = true;
    };

    go.enable = true;
    zsh.enable = true;
  };
}
