# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{ config, pkgs, inputs, lib, ... }:

let
  fenix = inputs.fenix;
in

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

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

    # GNOME
    (final: prev: {
      gnome = prev.gnome.overrideScope (gnomeFinal: gnomePrev: {
        mutter = gnomePrev.mutter.overrideAttrs (old: {
          src = pkgs.fetchgit {
            url = "https://gitlab.gnome.org/vanvugt/mutter.git";
            # GNOME 45: triple-buffering-v4-45
            rev = "0b896518b2028d9c4d6ea44806d093fd33793689";
            sha256 = "sha256-mzNy5GPlB2qkI2KEAErJQzO//uo8yO0kPQUwvGDwR4w=";
          };
        });
      });
    })

    # mpv
    (self: super: {
      mpv = super.mpv.override {
        scripts = with self.mpvScripts; [ mpris thumbfast ];
      };
    })

    # fenix
    (_: super: let pkgs = fenix.inputs.nixpkgs.legacyPackages.${super.system}; in fenix.overlays.default pkgs pkgs)

    # https://github.com/NixOS/nixpkgs/issues/300755
    (final: prev: {
      inherit (inputs.nixpkgs-yabridge.legacyPackages.${prev.system})
        yabridge;
    })

    # Albert
    (final: prev: {
      albert = prev.albert.overrideAttrs (old: rec {
        version = "0.22.17";
        src = prev.fetchFromGitHub {
          owner = "albertlauncher";
          repo = "albert";
          rev = "v${version}";
          sha256 = "sha256-2wu4bOQDKoZ4DDzTttXXRNDluvuJth7M1pCvJmYQ+f4=";
          fetchSubmodules = true;
        };
      });
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

  # Enable the GNOME Desktop Environment.
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
      brave
      firefox
      librewolf
      thunderbird
      ungoogled-chromium

      # Communications
      cinny-desktop
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
      mpv
      opusTools
      pavucontrol
      pipewire.jack
      playerctl
      pwvucontrol
      qjackctl
      spek

      # Audio Production
      ardour
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
      aseprite
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

      # Gaming Tools
      bottles
      goverlay
      lutris
      wineWowPackages.staging
      winetricks

      # Tools
      dconf2nix
      duperemove
      grc
      igir
      mat2
      nvitop
      pdfid
      yt-dlp
    ];
  };

  fonts.packages = with pkgs; [
    fira-code
    fira-code-symbols
    (nerdfonts.override { fonts = [ "FiraCode" "DroidSansMono" ]; })
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
    PATH = [
      "${XDG_BIN_HOME}"
    ];
  };

  environment.variables =
    let
      makePluginPath = format:
        (lib.makeSearchPath format [
          "$HOME/.nix-profile/lib"
          "/run/current-system/sw/lib"
          "/etc/profiles/per-user/$USER/lib"
        ])
        + ":$HOME/.${format}";
    in
    {
      # For Gnome
      GI_TYPELIB_PATH = "/run/current-system/sw/lib/girepository-1.0";

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

  environment.systemPackages = (with pkgs; [
    # Internet
    firefox
    qbittorrent-qt5

    # Video & Audio
    ffmpegthumbnailer

    # Networking
    tmux
    wget
    iperf3

    # Development
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
    gpick #X11
    grip
    hplip # scanner
    htop-vim
    meld
    mesa-demos
    nixpkgs-review
    pciutils
    wl-clipboard
    wl-color-picker
    xclip #X11

    # System
    keepassxc
    libavif
    libgtop
    libheif
    libjxl
    libsecret
    otpclient
    shared-mime-info
    unzip
    zip
  ])
  ++
  (with pkgs.lxqt; [
    lximage-qt
    lxqt-menu-data # For pcmanfm-qt
    pcmanfm-qt
    qps
  ])
  ++
  (with pkgs.libsForQt5; [
    filelight
    kdenlive
    ktouch
    okular
    kimageformats
    qt5.qtimageformats
  ])
  ++
  (with pkgs.qt6; [
    qtimageformats
  ])
  ;

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
