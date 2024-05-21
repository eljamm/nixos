{ ... }:

{
  imports = [
    ./bash
    ./fish
  ];

  home.sessionVariables = {
    # History
    HISTCONTROL = "ignoredups:erasedups";

    # Manpage
    MANPAGER = "moar";
    # MANPAGER="nvim -c 'set ft=man' -";
    # MANPAGER="nvimpager";
    # MANPAGER="sh -c 'col -bx | bat -l man -p'";

    # fzf: use the CLI fd to respect ignore files (like '.gitignore'),
    # display hidden files, and exclude the '.git' directory.
    FZF_DEFAULT_COMMAND = "fd . --hidden --exclude \".git\"";

    # Development
    DEVDIR = "$HOME/Development";
    VIRTUALENVWRAPPER_PYTHON = "python3";
  };

  home.shellAliases = {
    # Essentials
    clr = "clear && history -c";

    # Files
    la = "ls -A";
    ls = "eza -a --icons";
    lt = "eza -a --tree --level=2 --icons";
    ll = "eza -a -l --icons";
    llt = "eza -a -l --tree --level=2 --icons";

    # Utils
    mklist = "ls -I list.txt > list.txt";
    mklistt = "lt -I listt.txt > listt.txt";

    # Media
    mplv = "mpv --profile=480p";
    yts = "ytm -s";
    ytso = "ytm -so";
    ytv = "ytm -v";
    yti = "yt-dlp -F";
    ytps = "ytm -ps";
    ytpv = "ytm -p";
    ytvl = "ytm -v -f '\''bv[height<=480][vcodec~=vp9]+ba[acodec~=opus][abr<=96]/bv[height<=480][vcodec~=vp9]+ba[acodec~=opus]'\''";

    # Tools
    duperm = "duperemove -dr -h --hashfile=dupe.hash";

    # Git
    vcs-submodule = "git submodule update --init --recursive";

    # Programs
    l = "lazygit";
    n = "nvim";
  };
}
