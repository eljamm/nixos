{
  pkgs,
  pkgsCustom,
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

    direnv = {
      enable = true;
      enableBashIntegration = true;
      nix-direnv.enable = true;
    };

    git = {
      enable = true;
      lfs.enable = true;
      userName = "eljamm";
      userEmail = "***REMOVED***";
      aliases = {
        b = "branch";
        c = "clone";
        cc = "commit";
        co = "checkout";
        d = "diff";
        p = "push";
        # Rebase from another branch
        # - $1: first argument is the branch to rebase from (defaults to upstream)
        # - $@: arbitrary number of arguments afterwards (e.g. `--force`)
        rb = "!bash -c 'git pull --rebase \${1:-upstream} \"$(git rev-parse --abbrev-ref HEAD)\" \"$@\"'";
        s = "status";
      };
      extraConfig = {
        credential.helper = "${pkgs.git.override { withLibsecret = true; }}/bin/git-credential-libsecret";
      };
      difftastic = {
        enable = true;
        display = "inline";
        background = "dark";
      };
    };

    obs-studio = {
      enable = true;
      plugins =
        with pkgs.obs-studio-plugins;
        [
          obs-pipewire-audio-capture
          obs-vkcapture
          wlrobs
        ]
        ++ [ pkgsCustom.obs-studio-plugins.obs-backgroundremoval ];
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

    carapace = {
      enable = false;
      enableFishIntegration = false;
    };

    # NOTE: unused
    emacs = {
      enable = false;
      package = pkgs.emacs;
    };
  };
}
