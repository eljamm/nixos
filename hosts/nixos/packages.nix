{
  config,
  pkgs,
  lib,
  ...
}:
let
  packages = with pkgs; {
    internet = [
      firefox
      qbittorrent
    ];

    networking = [
      aria2
      iperf3
      tmux
      wget
    ];

    nix = [
      manix # documentation search
      nix-alien
      nix-init
      nix-inspect
      nix-output-monitor
      nix-tree
      nix-your-shell
      nixd
      nixpkgs-review
      npins
    ];

    python = [
      micromamba
      pipx
      python3
      python311Packages.pip
      python311Packages.virtualenv
      python311Packages.virtualenvwrapper
    ];

    office = [
      calibre
      goldendict-ng
      harper
      libreoffice-fresh
      yacreader
    ];

    lxqt = with lxqt; [
      lximage-qt
      lxqt-menu-data # For pcmanfm-qt
      pcmanfm-qt
      qps
    ];

    media = [
      alsa-utils
      ffmpegthumbnailer
      freetube
      mediainfo
      mediainfo-gui
      mkvtoolnix
      mkvtoolnix-cli
      opusTools
      pipewire.jack
      playerctl
      yt-dlp
    ];

    notes = [
      dstask
      logseq
      obsidian
      planify
      qownnotes
    ];

    qt5 = with libsForQt5; [
      filelight
      kdenlive
      ktouch
      okular
      kimageformats
      qt5.qtimageformats
    ];

    qt6 = with qt6; [ qtimageformats ];

    git = [
      gh
      git
      gitu
      lazygit
      python3Packages.grip
      rs-git-fsmonitor
      tig
    ];

    security = [
      bubblewrap
      keepassxc
      libsecret
      osslsigncode
      otpclient
    ];

    system = [
      dua
      eza
      fd
      hplip # scanner
      libavif
      libheif
      libjxl
      ouch
      ripgrep
      shared-mime-info # file types/pcmanfm-qt
      tree
      unzip
      zip

      # Utils
      gpick # X11
      ksnip
      wl-clipboard
      wl-color-picker
      xclip # X11
    ];

    productivity = [
      cheat
      homebank
      tellico
      termdown
    ];

    development = [
      addlicense
      meld
      tree-sitter

      # TODO: move to dev env?
      gnumake
      gcc
    ];

    tools = [
      bleachbit
      duperemove
      ghostscript
      gpu-viewer
      htop-vim
      innoextract
      jpegoptim
      lurk
      mat2
      mesa-demos
      optipng
      pciutils
      powerstat
      usbutils
      vulkan-tools
      xorg.xeyes
    ];
  };
in
{
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # TODO: make a module for packages
  environment.systemPackages = lib.pipe packages [
    (lib.mapAttrsToList (name: value: value))
    lib.flatten
  ];
}
