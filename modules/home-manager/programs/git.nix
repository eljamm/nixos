{ pkgs, ... }:
{
  programs.git = {
    enable = true;
    lfs.enable = true;
    settings = {
      user.name = "eljamm";
      alias = {
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
      credential.helper = "${pkgs.git.override { withLibsecret = true; }}/bin/git-credential-libsecret";
    };
  };

  programs.difftastic = {
    enable = true;
    git.enable = true;
    options.display = "inline";
    options.background = "dark";
  };
}
