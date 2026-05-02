{ pkgs, ... }:
{
  imports = [
    ./mpv.nix
    ./programs
    ./theme.nix
    ./wineasio.nix
  ];

  home = {
    packages = with pkgs; [
      difftastic
      moor
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

  xresources.properties = {
    "XTerm*faceName" = "JetBrains Mono NF Light";
    "XTerm*faceSize" = 12;
    "XTerm*externalBorder" = 10;
    "XTerm*internalBorder" = 20;

    # Catppuccin Macchiato
    # https://github.com/catppuccin/xresources
    "*background" = "#24273a";
    "*foreground" = "#cad3f5";
    "*cursorColor" = "#f4dbd6";

    # black
    "*color0" = "#494d64";
    "*color8" = "#5b6078";

    # red
    "*color1" = "#ed8796";
    "*color9" = "#ed8796";

    # green
    "*color2" = "#a6da95";
    "*color10" = "#a6da95";

    # yellow
    "*color3" = "#eed49f";
    "*color11" = "#eed49f";

    # blue
    "*color4" = "#8aadf4";
    "*color12" = "#8aadf4";

    # magenta
    "*color5" = "#f5bde6";
    "*color13" = "#f5bde6";

    # cyan
    "*color6" = "#8bd5ca";
    "*color14" = "#8bd5ca";

    # white
    "*color7" = "#b8c0e0";
    "*color15" = "#a5adcb";
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
