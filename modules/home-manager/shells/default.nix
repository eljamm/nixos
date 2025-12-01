{
  nixosConfig,
  ...
}:
let
  hostname = nixosConfig.networking.hostName;
in
{
  imports = [
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

  home.shellAliases = {
    # Files
    l = "ll";
    la = "ls -A";
    ll = "eza -a -l --icons";
    llt = "eza -a -l --tree --level=2 --icons";
    ls = "eza -a --icons";
    lt = "eza -a --tree --level=2 --icons";

    # Utils
    mklist = "ls -I list.txt > list.txt";
    mklistt = "lt -I listt.txt > listt.txt";

    # Media
    mplv = "mpv --profile=480p";
    yti = "yt-dlp -F";
    ytps = "ytm -ps";
    ytpv = "ytm -p";
    yts = "ytm -s";
    ytso = "ytm -so";
    ytv = "ytm -v";
    ytvl = "ytm -v -f '\''bv[height<=480][vcodec~=vp9]+ba[acodec~=opus][abr<=96]/bv[height<=480][vcodec~=vp9]+ba[acodec~=opus]'\''";

    # Tools
    duperm = "duperemove -dr -h --hashfile=dupe.hash";

    # Git
    g = "git";
    ghc = "gh pr checkout -f";
    ghr = "gh pr";
    vcs-submodule = "git submodule update --init --recursive";

    # Programs
    h = "harsh";
    k = "task";
    lg = "lazygit";
    man = "batman";
    nv = "nvim";
    tk = "taskwarrior-tui";
    y = "yazi";
    ze = "zellij";

    ## Nix
    nb = "nh os build -H ${hostname}";
    nbt = "nh os boot -H ${hostname}";
    ns = "nh os switch -H ${hostname}";
    nt = "nh os test -H ${hostname}";
    nbb = "nix-build . -A";
    ni = "nix-init";
    nr = "nix-direnv-reload";
    rpr = "nixpkgs-review pr";
  };
}
