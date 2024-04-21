{ pkgs, ... }:

{

  programs.zoxide = {
    enable = true;
    options = [
      "--cmd cd"
    ];
  };

  programs.bat = {
    enable = false;

    config = {
      theme = "ansi";
      pager = "less -FR --use-color -Dd+r -Du+b";
      # map-syntax = ["*.jenkinsfile:Groovy" "*.props:Java Properties"];
    };
  };

  programs.keychain = {
    enable = true;
    extraFlags = [ "--eval" "--noask" "--quiet" ];
    agents = [ "ssh" "gpg" ];
  };

  programs.direnv = {
    enable = true;
    enableBashIntegration = true;
    nix-direnv.enable = true;
  };

  programs.git = {
    enable = true;
    userName = "eljamm";
    userEmail = "***REMOVED***";
    aliases = {
      ci = "commit";
      co = "checkout";
      s = "status";
      d = "diff";
    };
    extraConfig = {
      credential.helper = "${
          pkgs.git.override { withLibsecret = true; }
        }/bin/git-credential-libsecret";
    };
  };

  programs.mangohud.enable = true;
  programs.taskwarrior.enable = true;
  programs.joshuto.enable = true;

  programs.starship.enable = true;
  programs.fzf = {
    enable = true;
    catppuccin.enable = true;
  };

}