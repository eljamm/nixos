{
  lib,
  pkgs,
  ...
}:
let
  homePackages = with pkgs; {
    internet = [
      birdtray
      brave
      firefox
      librewolf
      thunderbird
      ungoogled-chromium
    ];

    communications = [
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
      zrythm

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
      ki
    ];

    office = [
      crow-translate
      lifeograph
      mdbook
      mdbook-epub
      mdbook-i18n-helpers
      mdbook-pdf
      pdfid
      zathura
    ];

    system = [
      albert
      speechd
      copyq
    ];

    development = [
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
      grc
    ];
  };
in
{
  users.users.kuroko.packages = lib.pipe homePackages [
    (lib.mapAttrsToList (name: value: value))
    lib.flatten
  ];
}
