{ pkgs, inputs, ... }:

let
  customSystem = inputs.nixpkgs-system.legacyPackages.${pkgs.system};
in

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
        c = "clone";
        ci = "commit";
        co = "checkout";
        d = "diff";
        s = "status";
      };
      extraConfig = {
        credential.helper = "${pkgs.git.override { withLibsecret = true; }}/bin/git-credential-libsecret";
      };
    };

    obs-studio = {
      enable = true;
      plugins = with customSystem.obs-studio-plugins; [
        obs-backgroundremoval
        obs-pipewire-audio-capture
        obs-vkcapture
        wlrobs
      ];
    };

    mangohud.enable = true;
    taskwarrior.enable = true;
    joshuto.enable = true;

    starship.enable = true;
    fzf = {
      enable = true;
      catppuccin.enable = true;
    };

    zellij = {
      enable = true;
      catppuccin.enable = true;
    };

    go.enable = true;
    zsh.enable = true;
  };
}
