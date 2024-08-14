# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{ pkgs, inputs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./modules/nixos/services
    ./overlays
  ];

  documentation.nixos.enable = false;

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

  # Disable gnome-tracker (high resource consumption)
  services.gnome.tracker-miners.enable = false;
  services.gnome.tracker.enable = false;

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
    # TODO: categorize?
    packages = with pkgs; [
      # Internet
      birdtray
      brave
      firefox
      librewolf
      mailspring
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
      # aseprite # TODO: pin this (heavy build)
      drawio
      gimp
      inkscape
      krita
      pixelorama
      rnote
      waifu2x-converter-cpp

      # Education
      anki-bin
      anki-sync-server

      # Office
      crow-translate
      lifeograph
      mdbook
      mdbook-epub
      mdbook-i18n-helpers
      mdbook-pdf
      # ocrfeeder # TODO: broken
      zathura

      # System
      albert
      piper-tts
      speechd

      # Development
      # aoc-cli # TODO: move to aoc repo
      clang
      mold-wrapped
      neovide
      pkg-config
      sqlitebrowser
      tmuxifier

      # Tools
      copyq
      custom.pgsrip
      custom.vocabsieve
      dconf2nix
      duperemove
      grc
      igir
      ki
      llama-cpp
      mat2
      nvitop
      pdfid
      yt-dlp
    ];
  };

  services.xserver.wacom.enable = true;

  environment.sessionVariables = rec {
    XDG_CACHE_HOME = "$HOME/.cache";
    XDG_CONFIG_HOME = "$HOME/.config";
    XDG_DATA_HOME = "$HOME/.local/share";
    XDG_STATE_HOME = "$HOME/.local/state";

    # Not officially in the specification
    XDG_BIN_HOME = "$HOME/.local/bin";
    PATH = [ "${XDG_BIN_HOME}" ];
  };

  environment.variables = {
    QT_QPA_PLATFORM = "xcb"; # Force X11 for QT apps
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

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # TODO: categorize?
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
      gitu
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
      planify
      tellico
      termdown

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
      homebank
      hplip # scanner
      htop-vim
      ksnip
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
      nix-inspect
      nix-output-monitor
      nix-tree
      nixd
      nixpkgs-review
      npins

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

  services.redlib = {
    enable = true;
    package = pkgs.redlib;
  };

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
