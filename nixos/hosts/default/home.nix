{ config, pkgs, ... }:
let
  rustToolchain = pkgs.fenix.stable.withComponents [
    "cargo"
    "clippy"
    "rust-src"
    "rustc"
    "rustfmt"
    "rust-analyzer"
  ];
in

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "kuroko";
  home.homeDirectory = "/home/kuroko";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.11"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    # System
    bat
    difftastic
    moar
    zoxide

    ## Gnome
    gnomeExtensions.appindicator
    gnomeExtensions.user-themes
    gnomeExtensions.vitals
    gnomeExtensions.tophat
    gnomeExtensions.dash-to-panel
    gnomeExtensions.space-bar

    # Customization
    papirus-folders
    (catppuccin-kvantum.override {
      accent = "Blue";
      variant = "Macchiato";
    })

    ## QT
    libsForQt5.qtstyleplugin-kvantum
    libsForQt5.qt5ct

    # Development
    rustToolchain
  ];

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

  programs.starship = {
    enable = true;
  };

  gtk = {
    enable = true;
    theme = {
      name = "Catppuccin-Macchiato-Standard-Blue-Dark";
      package = pkgs.catppuccin-gtk.override {
        accents = [ "blue" ];
        size = "standard";
        variant = "macchiato";
      };
    };
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.catppuccin-papirus-folders.override {
        flavor = "macchiato";
        accent = "blue";
      };
    };
    cursorTheme = {
      name = "Catppuccin-Macchiato-Dark-Cursors";
      package = pkgs.catppuccin-cursors.macchiatoDark;
    };
    gtk3 = {
      extraConfig.gtk-application-prefer-dark-theme = true;
    };
  };

  home.pointerCursor = {
    gtk.enable = true;
    name = "Catppuccin-Macchiato-Dark-Cursors";
    package = pkgs.catppuccin-cursors.macchiatoDark;
    size = 16;
  };

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      gtk-theme = "Catppuccin-Macchiato-Standard-Blue-Dark";
      color-scheme = "prefer-dark";
      enable-hot-corners = true;
    };

    "org/gnome/shell" = {
      disable-user-extensions = false;

      # from `gnome-extensions list`
      enabled-extensions = [
        "user-theme@gnome-shell-extensions.gcampax.github.com"
        "appindicatorsupport@rgcjonas.gmail.com"
        # "Vitals@CoreCoding.com"
        "tophat@fflewddur.github.io"
        "dash-to-panel@jderose9.github.com"
        "space-bar@luchrioh"
      ];
    };

    "org/gnome/shell/extensions/user-theme" = {
      name = "Catppuccin-Macchiato-Standard-Blue-Dark";
    };

    "org/gnome/desktop/wm/keybindings" = {
      switch-applications = [ "<Alt>Tab" ];
      switch-applications-backward = [ "<Shift><Alt>Tab" ];
      switch-to-workspace-1 = [ "<Super>Home" "<Super>1" ];
      switch-to-workspace-2 = [ "<Super>2" ];
      switch-to-workspace-3 = [ "<Super>3" ];
      switch-to-workspace-4 = [ "<Super>4" ];
      switch-windows = [ "<Super>Tab" ];
      switch-windows-backward = [ "<Shift><Super>Tab" ];
    };
  };

  xdg.configFile."Kvantum/kvantum.kvconfig".source = (pkgs.formats.ini { }).generate "kvantum.kvconfig" {
    General.theme = "Catppuccin-Macchiato-Blue";
  };

  qt = {
    enable = true;
    platformTheme = "qtct";
    style.name = "kvantum";
  };

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

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

  programs.bash = {
    enable = true;
    sessionVariables = {
      VIRTUALENVWRAPPER_PYTHON = "python3"; # Temporary until next reboot
    };

    initExtra = ''
      # include .profile if it exists
      [[ -f ~/.profile ]] && . ~/.profile

      bind "set completion-ignore-case on"

      set show-all-if-ambiguous on
      set visible-stats on
      set page-completions off
      set -o vi # Vim mode on

      if [[ -x "$(command virtualenvwrapper.sh)" ]]; then
        source $(which virtualenvwrapper.sh)
      fi

      pdcompress() {
      	directory="compressed"
      	if [[ "$1" =~ "-d" ]]; then
      		if [[ ! -d "$PWD"/"$directory" ]]; then
      			mkdir "$PWD"/"$directory"
      		fi
      		shift
      		gs -sDEVICE=pdfwrite -dCompatibilityLevel=1.4 -dPDFSETTINGS=/ebook -dNOPAUSE -dQUIET -dBATCH -sOutputFile="$PWD"/"$directory"/"$1" "$1"
      	else
      		filename=$(echo "$1" | cut -f 1 -d '.')
      		gs -sDEVICE=pdfwrite -dCompatibilityLevel=1.4 -dPDFSETTINGS=/ebook -dNOPAUSE -dQUIET -dBATCH -sOutputFile="$filename"-out.pdf "$1"
      	fi
      }

      nixify() {
        if [ ! -e ./.envrc ]; then
          echo "use nix" > .envrc
          direnv allow
        fi
        if [[ ! -e shell.nix ]] && [[ ! -e default.nix ]]; then
          cat > default.nix <<'EOF'
      with import <nixpkgs> {};
      mkShell {
        nativeBuildInputs = [
          bashInteractive
        ];
      }
      EOF
          $\{EDITOR:-vim\} default.nix
        fi
      }
      flakify() {
        if [ ! -e flake.nix ]; then
          nix flake new -t github:nix-community/nix-direnv .
        elif [ ! -e .envrc ]; then
          echo "use flake" > .envrc
          direnv allow
        fi
        $\{EDITOR:-vim\} flake.nix
      }
    '';
  };

  # Check out:
  # https://github.com/calops/nix/blob/main/modules/home/config/programs/neovim/default.nix
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    extraPackages = with pkgs; [
      # Formatters
      alejandra # Nix
      black # Python
      gofumpt
      goimports-reviser
      golines
      isort
      nixpkgs-fmt
      prettierd # Multi-language
      ruff
      shfmt
      stylua

      # LSP
      gopls
      lua-language-server
      nil
      nodePackages.typescript-language-server
      python311Packages.jedi-language-server # Python
      ruff-lsp
      rustToolchain
      typst-lsp
      vscode-langservers-extracted # HTML/CSS/JSON/ESLint

      # Tools
      clang
      cmake
      codespell
      deno
      fswatch # File watcher utility, replacing libuv.fs_event for neovim 10.0
      fzf
      gcc
      gdtoolkit # parser, linter and formatter for Godot (GDScript)
      git
      gnumake
      go
      nodejs
      sqlite
      tree-sitter
    ];
  };

  programs.keychain = {
    enable = true;
    extraFlags = [ "--eval" "--noask" "--quiet" ];
    agents = [ "ssh" "gpg" ];
  };

  programs = {
    direnv = {
      enable = true;
      enableBashIntegration = true;
      nix-direnv.enable = true;
    };
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

  programs.mangohud = {
    enable = true;
  };

  xdg.mimeApps = {
    enable = true;
    associations.added = {
      "application/x-trash" = [ "neovide.desktop" ];
      "application/x-zerosize" = [ "neovide.desktop;" ];
      "application/xhtml+xml" = [ "librewolf.desktop" ];
      "inode/directory" = [ "pcmanfm-qt.desktop" ];
      "text/calendar" = [ "org.gnome.Calendar.desktop" ];
      "text/html" = [ "librewolf.desktop" ];
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
