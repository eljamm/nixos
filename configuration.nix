# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  config,
  pkgs,
  inputs,
  lib,
  ...
}:

let
  inherit (inputs) fenix;
in

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./modules/nixos/services
    ./modules/nixos/virtualisation.nix
  ];

  documentation.nixos.enable = false;

  nixpkgs.overlays = [
    # CCache
    (self: super: {
      ccacheWrapper = super.ccacheWrapper.override {
        extraConfig = ''
          export CCACHE_COMPRESS=1
          export CCACHE_DIR="${config.programs.ccache.cacheDir}"
          export CCACHE_UMASK=007
          if [ ! -d "$CCACHE_DIR" ]; then
            echo "====="
            echo "Directory '$CCACHE_DIR' does not exist"
            echo "Please create it with:"
            echo "  sudo mkdir -m0770 '$CCACHE_DIR'"
            echo "  sudo chown root:nixbld '$CCACHE_DIR'"
            echo "====="
            exit 1
          fi
          if [ ! -w "$CCACHE_DIR" ]; then
            echo "====="
            echo "Directory '$CCACHE_DIR' is not accessible for user $(whoami)"
            echo "Please verify its access permissions"
            echo "====="
            exit 1
          fi
        '';
      };
    })

    # GNOME dynamic triple buffering
    (final: prev: {
      gnome = prev.gnome.overrideScope (
        gnomeFinal: gnomePrev: {
          mutter = gnomePrev.mutter.overrideAttrs (old: {
            src = pkgs.fetchFromGitLab {
              domain = "gitlab.gnome.org";
              owner = "vanvugt";
              repo = "mutter";
              rev = "triple-buffering-v4-46";
              hash = "sha256-fkPjB/5DPBX06t7yj0Rb3UEuu5b9mu3aS+jhH18+lpI=";
            };
          });
        }
      );
    })

    # fenix
    (
      _: super:
      let
        pkgs = fenix.inputs.nixpkgs.legacyPackages.${super.system};
      in
      fenix.overlays.default pkgs pkgs
    )

    # Albert
    (final: prev: {
      albert = prev.albert.overrideAttrs rec {
        version = "0.24.2";
        src = prev.fetchFromGitHub {
          owner = "albertlauncher";
          repo = "albert";
          rev = "v${version}";
          sha256 = "sha256-Z88amcPb2jCJduRu8CGQ20y2o5cXmL4rpRL0hGCEYgM=";
          fetchSubmodules = true;
        };
        postPatch = ''
          find -type f -name CMakeLists.txt -exec sed -i {} -e '/INSTALL_RPATH/d' \;

          sed -i src/app/qtpluginprovider.cpp \
            -e "/QStringList install_paths;/a    install_paths << QFileInfo(\"$out/lib\").canonicalFilePath();"
        '';
      };
    })

    # Gamescope
    (final: prev: {
      gamescope = prev.gamescope.overrideAttrs (old: rec {
        version = "3.14.2";
        src = prev.fetchFromGitHub {
          owner = "ValveSoftware";
          repo = "gamescope";
          rev = "refs/tags/${version}";
          fetchSubmodules = true;
          hash = "sha256-Ym1kl9naAm1MGlxCk32ssvfiOlstHiZPy7Ga8EZegus=";
        };
      });
    })

    # AI
    (final: prev: {
      llama-cpp =
        (prev.llama-cpp.overrideAttrs (old: rec {
          version = "2953";
          src = prev.fetchFromGitHub {
            owner = "ggerganov";
            repo = "llama.cpp";
            rev = "refs/tags/b${version}";
            hash = "sha256-IqR0tdTdrydrMCgOfNbRnVESN3pEzti3bAuTH9i3wQQ=";
            leaveDotGit = true;
            postFetch = ''
              git -C "$out" rev-parse --short HEAD > $out/COMMIT
              find "$out" -name .git -print0 | xargs -0 rm -rf
            '';
          };
        })).override
          { cudaSupport = true; };
    })

    # System overrides
    (
      final: prev:
      let
        customSystem = inputs.nixpkgs-system.legacyPackages.${prev.system};
        freetubeSystem = inputs.nixpkgs-freetube.legacyPackages.${prev.system};
      in
      {
        inherit (customSystem) pgsrip ki vocabsieve;
        inherit (freetubeSystem) freetube;
        obs-studio-plugins.obs-backgroundremoval = customSystem.obs-studio-plugins.obs-backgroundremoval;
      }
    )

    # Logseq
    (final: prev: {
      logseq = prev.logseq.overrideAttrs (old: rec {
        version = "0.10.9";
        src = pkgs.fetchurl {
          url = "https://github.com/logseq/logseq/releases/download/${version}/logseq-linux-x64-${version}.AppImage";
          hash = "sha256-XROuY2RlKnGvK1VNvzauHuLJiveXVKrIYPppoz8fCmc=";
          name = "${old.pname}-${version}.AppImage";
        };
        postFixup = ''
          # set the env "LOCAL_GIT_DIRECTORY" for dugite so that we can use the git in nixpkgs
          makeWrapper ${prev.electron}/bin/electron $out/bin/${old.pname} \
            --set "LOCAL_GIT_DIRECTORY" ${prev.git} \
            --add-flags $out/share/${old.pname}/resources/app \
            --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations}}" \
            --prefix LD_LIBRARY_PATH : "${prev.lib.makeLibraryPath [ prev.stdenv.cc.cc.lib ]}"
        '';
      });
    })
  ];

  # CCache
  nix.settings.extra-sandbox-paths = [ config.programs.ccache.cacheDir ];

  # Bootloader.
  # boot.loader.grub.enable = true;
  # boot.loader.grub.device = "/dev/vda";
  # boot.loader.grub.useOSProber = true;
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Africa/Tunis";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # Enable the COSMIC Desktop Environment.
  services.displayManager.cosmic-greeter.enable = false;
  services.desktopManager.cosmic.enable = false;

  # Configure keymap in X11
  services.xserver = {
    xkb = {
      layout = "de";
      variant = "nodeadkeys";
    };
  };

  # Configure console keymap
  console.keyMap = "de-latin1-nodeadkeys";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  sound.enable = false;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.kuroko = {
    isNormalUser = true;
    description = "kuroko";
    extraGroups = [
      "adbusers"
      "audio"
      "gamemode"
      "networkmanager"
      "wheel"
    ];
    packages = with pkgs; [
      # Internet
      birdtray
      brave
      firefox
      librewolf
      thunderbird
      ungoogled-chromium

      # Communications
      cinny-desktop
      element-desktop
      ferdium

      # Video & Audio
      alsa-utils
      audacious
      audacious-plugins
      audacity
      bambootracker
      flacon
      freetube
      furnace
      handbrake
      helvum
      kid3
      mediainfo
      mediainfo-gui
      mkvtoolnix
      mkvtoolnix-cli
      opusTools
      pavucontrol
      pipewire.jack
      playerctl
      pwvucontrol
      qjackctl
      spek

      # Audio Production
      ardour
      ffmpeg
      helio-workstation
      infamousPlugins
      linvstmanager
      lmms
      lsp-plugins
      vital
      yabridge
      yabridgectl

      # Game Development
      godot_4
      godot3

      # Graphics
      aseprite # TODO: pin this
      gimp
      inkscape
      krita
      pixelorama
      rnote
      waifu2x-converter-cpp

      # Games
      osu-lazer-bin
      prismlauncher
      ryujinx
      mgba
      vbam

      # Education
      anki-bin
      anki-sync-server
      stellarium

      # Office
      crow-translate
      lifeograph
      mdbook
      mdbook-epub
      mdbook-i18n-helpers
      mdbook-pdf
      ocrfeeder
      zathura

      # System
      albert
      kitty
      piper-tts
      speechd

      # Development
      aoc-cli
      clang
      mold-wrapped
      neovide
      pkg-config
      tmuxifier

      # Gaming Tools
      bottles
      cubiomes-viewer
      goverlay
      heroic
      inputs.umu.packages.${pkgs.system}.umu
      lutris
      wineWowPackages.staging
      winetricks

      # Tools
      copyq
      dconf2nix
      duperemove
      grc
      igir
      ki
      llama-cpp
      mat2
      nvitop
      pdfid
      pgsrip
      vocabsieve
      yt-dlp
    ];
  };

  fonts.packages = with pkgs; [
    fira-code
    fira-code-symbols
    (nerdfonts.override {
      fonts = [
        "FiraCode"
        "DroidSansMono"
      ];
    })
  ];

  systemd.packages = [ pkgs.anki-sync-server ];

  services.anki-sync-server = {
    enable = true;
    users = [
      {
        username = "kuroko";
        passwordFile = /etc/anki-sync-server/kuroko;
      }
    ];
    address = "0.0.0.0";
    port = 27701;
    openFirewall = true;
  };

  services.xserver.wacom.enable = true;

  # This is using a rec (recursive) expression to set and access XDG_BIN_HOME within the expression
  # For more on rec expressions see https://nix.dev/tutorials/first-steps/nix-language#recursive-attribute-set-rec
  environment.sessionVariables = rec {
    XDG_CACHE_HOME = "$HOME/.cache";
    XDG_CONFIG_HOME = "$HOME/.config";
    XDG_DATA_HOME = "$HOME/.local/share";
    XDG_STATE_HOME = "$HOME/.local/state";

    # Not officially in the specification
    XDG_BIN_HOME = "$HOME/.local/bin";
    PATH = [ "${XDG_BIN_HOME}" ];
  };

  environment.variables =
    let
      makePluginPath =
        format:
        (lib.makeSearchPath format [
          "$HOME/.nix-profile/lib"
          "/run/current-system/sw/lib"
          "/etc/profiles/per-user/$USER/lib"
        ])
        + ":$HOME/.${format}";
    in
    {
      QT_QPA_PLATFORM = "xcb"; # Force X11 for QT apps

      # Music plugin paths
      DSSI_PATH = makePluginPath "dssi";
      LADSPA_PATH = makePluginPath "ladspa";
      LV2_PATH = makePluginPath "lv2";
      LXVST_PATH = makePluginPath "lxvst";
      VST_PATH = makePluginPath "vst";
      VST3_PATH = makePluginPath "vst3";
    };

  # Register AppImage files as a binary type
  boot.binfmt.registrations.appimage = {
    wrapInterpreterInShell = false;
    interpreter = "${pkgs.appimage-run}/bin/appimage-run";
    recognitionType = "magic";
    offset = 0;
    mask = ''\xff\xff\xff\xff\x00\x00\x00\x00\xff\xff\xff'';
    magicOrExtension = ''\x7fELF....AI\x02'';
  };

  # Enable flakes
  nix = {
    package = pkgs.nixFlakes;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages =
    (with pkgs; [
      # Internet
      firefox
      qbittorrent-qt5

      # Video & Audio
      ffmpegthumbnailer

      # Networking
      aria2
      iperf3
      tmux
      wget

      # Development
      addlicense
      alejandra
      gcc
      gh
      git
      gnumake
      lazygit
      micromamba
      pipx
      python3
      python311Packages.pip
      python311Packages.virtualenv
      python311Packages.virtualenvwrapper
      rs-git-fsmonitor
      tig
      tree-sitter

      # Office
      calibre
      libreoffice-fresh
      yacreader

      # Productivity
      dstask
      gnome.pomodoro
      planify
      tellico

      # Security
      bubblewrap

      # Tools
      dua
      eza
      fd
      ghostscript
      goldendict-ng
      innoextract
      jpegoptim
      optipng
      osslsigncode
      ripgrep
      tree
      xorg.xeyes

      # Note Taking
      qownnotes
      logseq
      obsidian

      # Utils
      bleachbit
      cheat
      gpick # X11
      gpu-viewer
      hplip # scanner
      htop-vim
      ksnip
      lenovo-legion
      lurk
      meld
      mesa-demos
      ouch
      pciutils
      powerstat
      python3Packages.grip
      usbutils
      vulkan-tools
      wl-clipboard
      wl-color-picker
      xclip # X11

      # Nix
      manix # documentation search
      nix-alien
      nix-init
      nix-output-monitor
      nix-tree
      nixpkgs-review

      # System
      keepassxc
      libavif
      libheif
      libjxl
      libsecret
      otpclient
      shared-mime-info
      unzip
      zip
    ])
    ++ (with pkgs.lxqt; [
      lximage-qt
      lxqt-menu-data # For pcmanfm-qt
      pcmanfm-qt
      qps
    ])
    ++ (with pkgs.libsForQt5; [
      filelight
      kdenlive
      ktouch
      okular
      kimageformats
      qt5.qtimageformats
    ])
    ++ (with pkgs.qt6; [ qtimageformats ]);

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  programs.firejail.enable = true;

  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = false; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = false; # Open ports in the firewall for Source Dedicated Server
  };

  programs.gamemode = {
    enable = true;
    settings = {
      general = {
        renice = 10;
      };
      custom = {
        start = "${pkgs.libnotify}/bin/notify-send 'GameMode started'";
        end = "${pkgs.libnotify}/bin/notify-send 'GameMode ended'";
      };
    };
  };
  programs.gamescope.enable = true;

  programs.adb.enable = true;

  programs.hyprland.enable = true;

  programs.nix-ld.enable = true;
  services.envfs.enable = true;

  # Output more information when building the system:
  # https://discourse.nixos.org/t/how-to-make-nixos-rebuild-output-more-informative/25549/11
  system.activationScripts.diff = # bash
    ''
      if [[ -e /run/current-system ]]; then
        echo
        ${pkgs.nix}/bin/nix store diff-closures /run/current-system "$systemConfig" | grep -w "→" | grep -w "KiB" | column --table --separator " ,:" | ${pkgs.choose}/bin/choose :1 -4: | ${pkgs.gawk}/bin/awk '{s=$0; gsub(/\033\[[ -?]*[@-~]/,"",s); print s "\t" $0}' | sort -k5,5gr | ${pkgs.choose}/bin/choose 6: | column --table
        Sum=$(${pkgs.nix}/bin/nix store diff-closures /run/current-system "$systemConfig" | grep -w "→" | grep -w "KiB" | column --table --separator " ,:" | ${pkgs.choose}/bin/choose -2 | ${pkgs.ansifilter}/bin/ansifilter | tr "\n" " " | ${pkgs.gawk}/bin/awk 'NR == 1 { $0 = "0" $0 }; 1' | ${pkgs.bc}/bin/bc -l)
        if (( $(echo "$Sum != 0" | ${pkgs.bc}/bin/bc -l) )); then
        SumMiB=$(echo "scale=2; $Sum/1024" | ${pkgs.bc}/bin/bc -l)
        echo -en "\nSum: "
        if (( $(echo "$SumMiB > 0" | ${pkgs.bc}/bin/bc -l) )); then TERM=xterm-256color ${pkgs.ncurses}/bin/tput setaf 1; elif (( $(echo "$SumMiB < 0" | ${pkgs.bc}/bin/bc -l) )); then TERM=xterm-256color ${pkgs.ncurses}/bin/tput setaf 2; fi
        echo -e "$SumMiB MiB\n"
        TERM=xterm-256color ${pkgs.ncurses}/bin/tput setaf 7
        fi
      fi
    '';

  programs.nh = {
    enable = true;
    flake = "/home/kuroko/nixos";
  };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = false;
    # require public key authentication for better security
    settings.PasswordAuthentication = false;
    settings.KbdInteractiveAuthentication = false;
    #settings.PermitRootLogin = "yes";
  };

  services.libreddit = {
    enable = true;
    package = pkgs.redlib;
  };

  services.gnome.tracker-miners.enable = false;
  services.gnome.tracker.enable = false;

  # Storage Optimization
  nix.optimise.automatic = true;

  # Incremental Builds
  programs.ccache.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?
}
