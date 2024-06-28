{ pkgs, ... }:

{
  imports = [
    ./gnome
    ./mpv.nix
    ./neovim
    ./programs
    ./shell
    ./theme.nix
    ./wezterm
  ];

  home = {
    # Home Manager needs a bit of information about you and the paths it should
    # manage.
    username = "kuroko";
    homeDirectory = "/home/kuroko";

    # This value determines the Home Manager release that your configuration is
    # compatible with. This helps avoid breakage when a new Home Manager release
    # introduces backwards incompatible changes.
    #
    # You should not change this value, even if you update Home Manager. If you do
    # want to update the value, then make sure to first check the Home Manager
    # release notes.
    stateVersion = "23.11"; # Please read the comment before changing.

    packages = with pkgs; [
      difftastic
      moar
      taskwarrior-tui
      zoxide
      devenv
    ];

    file = {
      # # Building this configuration will create a copy of 'dotfiles/screenrc' in
      # # the Nix store. Activating the configuration will then make '~/.screenrc' a
      # # symlink to the Nix store copy.
      # ".screenrc".source = dotfiles/screenrc;

      # # You can also set the file content immediately.
      # ".gradle/gradle.properties".text = ''
      #   org.gradle.console=verbose
      #   org.gradle.daemon.idletimeout=3600000
      # '';

      ## Thumbnailers
      ".local/share/thumbnailers/audio.thumbnailer".text = ''
        [Thumbnailer Entry]
        TryExec=ffmpegthumbnailer
        Exec=${pkgs.ffmpegthumbnailer}/bin/ffmpegthumbnailer -i %i -o %o -s %s
        MimeType=audio/x-opus+ogg;audio/x-matroska;audio/flac
      '';
      ".local/share/thumbnailers/krita.thumbnailer".text = ''
        [Thumbnailer Entry]
        TryExec=unzip
        Exec=sh -c "${pkgs.unzip}/bin/unzip -p %i preview.png > %o"
        MimeType=application/x-krita;
      '';
    };
  };

  services = {

    flameshot = {
      enable = true;
      # settings.General = {
      #   showStartupLaunchMessage = false;
      #   saveLastRegion = true;
      # };
    };

    easyeffects.enable = true;

    activitywatch = {
      enable = false;
      extraOptions = [
        "--port"
        "5600"
      ];
      watchers = {
        aw-watcher-afk.package = pkgs.activitywatch;
        aw-watcher-window.package = pkgs.activitywatch;
      };
    };
  };

  xdg.mimeApps = {
    enable = true;
    associations.added = {
      "application/x-trash" = [ "neovide.desktop" ];
      "application/x-zerosize" = [ "neovide.desktop;" ];
      "application/xhtml+xml" = [ "librewolf.desktop" ];
      "image/jxl" = [ "lximage-qt.desktop" ];
      "inode/directory" = [ "pcmanfm-qt.desktop" ];
      "text/calendar" = [ "org.gnome.Calendar.desktop" ];
      "text/html" = [ "librewolf.desktop" ];
      "text/plain" = [ "org.gnome.Meld.desktop" ];
      "x-scheme-handler/http" = [ "librewolf.desktop" ];
      "x-scheme-handler/https" = [ "librewolf.desktop" ];
      "x-scheme-handler/mailto" = [ "thunderbird.desktop" ];
    };
    defaultApplications = {
      "application/xhtml+xml" = [ "librewolf.desktop" ];
      "inode/directory" = [ "pcmanfm-qt.desktop" ];
      "text/calendar" = [ "org.gnome.Calendar.desktop" ];
      "text/html" = [ "librewolf.desktop" ];
      "video/x-matroska" = [ "spek.desktop;" ];
      "x-scheme-handler/http" = [ "librewolf.desktop" ];
      "x-scheme-handler/https" = [ "librewolf.desktop" ];
      "x-scheme-handler/mailto" = [ "thunderbird.desktop" ];
    };
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
