{
  lib,
  pkgs,
  pkgsUnstable,
  pkgsCustom,
  devLib,
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
      dig
      iperf3
      nmap
      tmux
      traceroute
      wakelan
      wget
      wol
    ];

    nix = [
      manix # documentation search
      nix-init
      # nix-inspect # TODO: old nix
      nix-output-monitor
      nix-tree
      nix-your-shell
      nixos-generators
      # pkgsCustom.agenix # TODO:
      pkgsUnstable.hydra-check
      pkgsUnstable.nix-update
      pkgsUnstable.nixpkgs-review
      pkgsUnstable.ragenix
      npins
    ];

    python = [
      pipx
      python3
      python3Packages.pip
      python3Packages.virtualenv
      python3Packages.virtualenvwrapper
      python3Packages.pyinstrument
      memray
    ];

    office = [
      calibre
      goldendict-ng
      harper
      libreoffice-fresh
      percollate # web pages -> pdf, epub, md
      readest
      projecteur
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
      pkgsUnstable.feishin
      ffmpegthumbnailer
      freetube
      mediainfo
      mediainfo-gui
      (lib.hiPrio mkvtoolnix)
      mkvtoolnix-cli
      opusTools
      pipewire.jack
      playerctl
      yt-dlp
    ];

    notes = [
      dstask
      obsidian
      pkgsUnstable.planify
      qownnotes
    ];

    qt6 = with kdePackages; [
      filelight
      kdenlive
      kimageformats
      okular
      qtimageformats
    ];

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
      hyperfine # benchmarking
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
      harsh
      homebank
      tealdeer
      tellico
      termdown
    ];

    development = [
      addlicense
      flamelens
      license-cli
      meld
      pkgsUnstable.act
      pkgsUnstable.ffizer
      pkgsUnstable.zizmor
      pre-commit
      tree-sitter
      watchexec
    ];

    tools = [
      bleachbit
      duf # disk usage/free
      duperemove
      ghostscript
      gpu-viewer
      htop-vim
      innoextract
      jjui
      jpegoptim
      jujutsu
      lurk
      mat2
      mdserve
      mesa-demos
      opencode
      optipng
      pciutils
      powerstat
      python3Packages.edge-tts
      trash-cli
      usbutils
      vulkan-tools
      xorg.xeyes
    ];
  };
in
{
  # TODO: make a module for packages
  environment.systemPackages = lib.pipe packages [
    lib.attrValues
    lib.flatten
  ];
}
