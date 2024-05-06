{ pkgs, ... }:

{

  programs.zoxide = {
    enable = true;
    options = [
      "--cmd cd"
    ];
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
    lfs.enable = true;
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

  programs.obs-studio = {
    enable = true;
    plugins = with pkgs.obs-studio-plugins; [
      obs-backgroundremoval
      obs-pipewire-audio-capture
      obs-vkcapture
      wlrobs
    ];
  };

  programs.mangohud.enable = true;
  programs.taskwarrior.enable = true;
  programs.joshuto.enable = true;

  programs.starship.enable = true;
  programs.fzf = {
    enable = true;
    catppuccin.enable = true;
  };

  programs.zellij = {
    enable = true;
    catppuccin.enable = true;
  };

}
