{
  imports = [
    ./aliases.nix
    ./bash
    ./fish
  ];

  home.sessionVariables = {
    # History
    HISTCONTROL = "ignoredups:erasedups";

    # Manpage
    # MANPAGER = "moor";
    # MANPAGER="nvim -c 'set ft=man' -";
    # MANPAGER="nvimpager";
    MANPAGER = "sh -c 'col -bx | bat -l man -p'"; # bat
    MANROFFOPT = "-c"; # for bat

    # fzf: use the CLI fd to respect ignore files (like '.gitignore'),
    # display hidden files, and exclude the '.git' directory.
    FZF_DEFAULT_COMMAND = "fd . --hidden --exclude \".git\"";

    # Development
    DEVDIR = "$HOME/Development";
    VIRTUALENVWRAPPER_PYTHON = "python3";
  };
}
