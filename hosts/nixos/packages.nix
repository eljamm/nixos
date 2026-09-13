{
  lib,
  pkgs,
  pkgsUnstable,
  pkgsCustom,
  ...
}:
{
  custom.systemPackages = with pkgs; {
    internet = [
      birdtray
      brave
      firefox
      librewolf
      qbittorrent
      thunderbird
      ungoogled-chromium
    ];

    chat = [
      discord
      element-desktop
      ferdium
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

    office = {
      comics = [
        yacreader
      ];
      ebook = [
        calibre
        readest
      ];
      pdf = [
        ocamlPackages.cpdf
        pdfmixtool
        pkgsCustom.pdfid
        zathura
      ];
      other = [
        crow-translate
        goldendict-ng
        libreoffice-fresh
        lifeograph
        ocrfeeder
        percollate # web pages -> pdf, epub, md
        projecteur
      ];
    };

    education = [
      anki
      ki
      pkgsCustom.vocabsieve
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

      audacious
      audacious-plugins
      audacity
      ffmpeg
      flacon
      handbrake
      crosspipe
      kid3
      pavucontrol
      pwvucontrol
      qjackctl
      spek
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

    vcs = [
      gh
      git
      gitu
      jjui
      jujutsu
      lazygit
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

    system = {
      launchers = [
        albert
        wox
      ];
      disk = [
        dua
        exfatprogs
        gparted
      ];
      libraries = [
        libavif
        libheif
        libjxl
      ];
      utils = [
        gpick # X11
        ksnip
        wl-clipboard
        wl-color-picker
        xclip # X11
      ];
      other = [
        copyq
        speechd
        shared-mime-info # file types/pcmanfm-qt
      ];
    };

    productivity = [
      cheat
      harsh
      tealdeer
      tellico
      termdown
      zeal
    ];

    development = {
      audio = {
        trackers = [
          bambootracker
          furnace
          pkgsUnstable.famistudio
          tuxguitar
        ];
        daws = [
          ardour
          helio-workstation
          lmms
          zrythm
        ];
        dj = [
          mixxx
        ];
        plugins = [
          airwindows
          airwindows-lv2
          carla
          distrho-ports
          geonkick
          infamousPlugins
          lsp-plugins
          ninjas2
          odin2
          pkgsUnstable.ripplerx
          # FIX:
          # pkgsUnstable.vaporizer2
          # surge
          tunefish
          vcv-rack
          vital
          x42-avldrums
          yabridge
          yabridgectl
          aether-lv2
        ];
        tools = [
          dl-librescore
          abcm2ps
          abcmidi
          easyabc
          lrcget
          wineasio
        ];
      };
      games = [
        godot3
        godot_4
        pkgsUnstable.arrow
      ];
      other = [
        addlicense
        degit # for downloading git sub-dirs
        dive # explore docker image layers
        flamelens
        git-ignore
        harper
        license-cli
        meld
        patchelf
        pkgsUnstable.arwen
        pkgsUnstable.act
        pkgsUnstable.ffizer
        pkgsUnstable.zizmor
        pre-commit
        python3Packages.grip
        sccache
        tree-sitter
        watchexec
        mold
        sqlitebrowser
      ];
    };

    tools = {
      ai = [
        opencode
      ];
      cleanup = [
        bleachbit
        duf # disk usage/free
        duperemove
      ];
      drawing = [
        aseprite
        blender
        gimp
        inkscape
        krita
        pixelorama
        rnote
      ];
      graphics = [
        gpu-viewer
        mesa-demos
        realesrgan-ncnn-vulkan
        vulkan-tools
        waifu2x-converter-cpp
        pkgsCustom.waifu2x-ncnn-vulkan
      ];
      other = [
        android-tools
        ghostscript
        htop-vim
        innoextract
        jpegoptim
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

    utils = [
      eza
      fd
      grc
      hyperfine # benchmarking
      ouch
      piper-tts
      ripgrep
      tree
      unzip
      zip
    ];
  };
}
