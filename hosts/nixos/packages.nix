{
  lib,
  pkgs,
  pkgsUnstable,
  ...
}:
{
  custom.systemPackages = with pkgs; {
    internet = [
      firefox
      qbittorrent
    ];

    networking = [
      aria2
      dig
      iperf3
      mtr-gui
      nmap
      tmux
      traceroute
      wakelan
      wget
      wol
    ];

    nix = [
      manix # documentation search
      pkgsUnstable.nix-init
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
      pkgsUnstable.nix-sweep
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
      ocrfeeder
      ocamlPackages.cpdf
      pdfmixtool
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
      digikam
      freetube
      mediainfo
      mediainfo-gui
      (lib.hiPrio mkvtoolnix)
      mkvtoolnix-cli
      opus-tools
      pipewire.jack
      playerctl
      yt-dlp
      gpodder
      musicpod
      stremio-linux-shell
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
      exfatprogs
      eza
      fd
      gparted
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
      zeal
    ];

    development = [
      addlicense
      degit # for downloading git sub-dirs
      dive # explore docker image layers
      flamelens
      git-ignore
      license-cli
      meld
      patchelf
      pkgsUnstable.arwen
      pkgsUnstable.act
      pkgsUnstable.ffizer
      pkgsUnstable.zizmor
      pre-commit
      sccache
      tree-sitter
      watchexec
    ];

    tools = {
      ai = [
        opencode
      ];
      cleanup = [
        bleachbit
        duf # disk usage/free
        duperemove
      ];
      graphics = [
        gpu-viewer
        mesa-demos
        vulkan-tools
      ];
      other = [
        android-tools
        ghostscript
        htop-vim
        innoextract
        jjui
        jpegoptim
        jujutsu
        lurk
        mat2
        mdserve
        optipng
        pciutils
        powerstat
        python3Packages.edge-tts
        showmethekey
        trash-cli
        usbutils
        watchman
        xeyes
      ];
    };
  };
}
