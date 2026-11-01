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
      # nix-inspect # TODO: old nix
      nix-output-monitor
      nix-tree
      nix-your-shell
      nixos-generators
      npins
      pkgsCustom.rom
      pkgsUnstable.devenv
      pkgsUnstable.hydra-check
      pkgsUnstable.nix-init
      pkgsUnstable.nix-sweep
      pkgsUnstable.nix-update
      pkgsUnstable.nixpkgs-review
      pkgsUnstable.ragenix
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
        (mkLazyApp goldendict-ng)
        libreoffice-fresh
        lifeograph
        (mkLazyApp ocrfeeder)
        (mkLazyApp percollate) # web pages -> pdf, epub, md
        projecteur
      ];
    };

    education = [
      ki
      pkgsCustom.anki
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
      (mkLazyApp pkgsUnstable.feishin)
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
      (mkLazyApp pkgsUnstable.planify)
      qownnotes
    ];

    qt6 = with kdePackages; [
      filelight
      (mkLazyApp kdenlive)
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
        (mkLazyApp pkgsUnstable.pgsrip)
        (mkLazyApp pkgsUnstable.whisper-ctranslate2)
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
      pkgsUnstable.super-productivity
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
          (mkLazyApp tuxguitar)
        ];
        daws = [
          ardour
          (mkLazyApp helio-workstation)
          lmms
          (mkLazyApp zrythm)
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
          (mkLazyApp yabridge)
          (mkLazyApp yabridgectl)
          aether-lv2
        ];
        tools = [
          dl-librescore
          abcm2ps
          abcmidi
          (mkLazyApp easyabc)
          lrcget
          wineasio
        ];
      };
      games = [
        (mkLazyApp godot3)
        godot_4
        (mkLazyApp pkgsUnstable.arrow)
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
        mat2
      ];
      drawing = [
        (mkLazyApp drawio)
        aseprite
        (mkLazyApp blender)
        gimp
        inkscape
        (mkLazyApp krita)
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
        lurk # prettier strace
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
      (mkLazyApp piper-tts)
      ripgrep
      tree
      unzip
      zip
    ];
  };
}
