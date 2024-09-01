{
  pkgs,
  ...
}:
{
  homePackages = with pkgs; {
    internet = [
      birdtray
      brave
      firefox
      librewolf
      mailspring
      thunderbird
      ungoogled-chromium
    ];

    communications = [
      # cinny-desktop # FIX: broken
      element-desktop
      ferdium
    ];

    media = [
      audacious
      audacious-plugins
      audacity
      ffmpeg
      flacon
      handbrake
      helvum
      kid3
      pavucontrol
      pwvucontrol
      qjackctl
      spek
    ];

    audioProduction = [
      # Trackers
      bambootracker
      furnace

      # DAWs
      ardour
      helio-workstation
      lmms

      # Plugins
      infamousPlugins
      lsp-plugins
      vital

      yabridge
      yabridgectl
    ];

    gameDevelopment = [
      godot_4
      godot3
    ];

    graphics = [
      # aseprite # TODO: pin this (heavy build)
      drawio
      gimp
      inkscape
      krita
      pixelorama
      rnote
      waifu2x-converter-cpp
    ];

    education = [
      anki-bin
      anki-sync-server
      custom.vocabsieve
      ki
    ];

    office = [
      crow-translate
      lifeograph
      mdbook
      mdbook-epub
      mdbook-i18n-helpers
      mdbook-pdf
      # ocrfeeder # TODO: still broken?
      pdfid
      zathura
    ];

    system = [
      albert
      speechd
      copyq
    ];

    development = [
      android-studio # WIP:
      # aoc-cli # TODO: move to aoc repo
      clang
      mold-wrapped
      neovide
      pkg-config
      sqlitebrowser
      tmuxifier
    ];

    utils = [
      (llama-cpp.override { cudaSupport = true; })
      piper-tts
      custom.pgsrip
      grc
    ];
  };
}
