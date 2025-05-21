{ pkgs, ... }:
{
  imports = [
    ./mpv.nix
    ./programs
    ./theme.nix
  ];

  home = {
    packages = with pkgs; [
      difftastic
      moar
      taskwarrior-tui
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

    # This value determines the Home Manager release that your configuration is
    # compatible with. This helps avoid breakage when a new Home Manager release
    # introduces backwards incompatible changes.
    #
    # You should not change this value, even if you update Home Manager. If you do
    # want to update the value, then make sure to first check the Home Manager
    # release notes.
    stateVersion = "23.11"; # Please read the comment before changing.
  };

  services = {
    # TODO: is this still useful?
    easyeffects.enable = true;

    # self-induced telemetry
    activitywatch = {
      enable = true;
      package = pkgs.aw-server-rust;
      extraOptions = [
        "--port"
        "5600"
      ];
      watchers = {
        awatcher.package = pkgs.awatcher;
        aw-sync.package = pkgs.aw-server-rust;
      };
    };
  };

  xdg.dataFile."mime/packages/drawio.xml".text = ''
    <?xml version="1.0" encoding="utf-8"?>
    <mime-info xmlns="http://www.freedesktop.org/standards/shared-mime-info">
    <mime-type type="application/vnd.jgraph.mxfile">
      <glob pattern="*.drawio"/>
        <comment>draw.io Diagram</comment>
      <icon name="x-office-document" />
    </mime-type>
    <mime-type type="application/vnd.visio">
      <glob pattern="*.vsdx"/>
        <comment>VSDX Document</comment>
      <icon name="x-office-document" />
    </mime-type>
    </mime-info>
  '';

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
