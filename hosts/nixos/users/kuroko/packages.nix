{
  lib,
  pkgs,
  pkgsCustom,
  pkgsUnstable,
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
      geonkick
      infamousPlugins
      lsp-plugins
      vital
      x42-avldrums

      yabridge
      yabridgectl
    ];

    gameDevelopment = [
      godot_4
      godot3
    ];

    graphics = [
      # aseprite
      drawio # TODO: remove?
      gimp
      inkscape
      krita # TODO: remove?
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
      mdbook # TODO: remove?
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
      pkg-config
      sqlitebrowser
      tmuxifier # TODO: remove?
    ];

    utils = [
      (pkgsUnstable.llama-cpp.override { cudaSupport = true; })
      piper-tts
      grc
      whisper-ctranslate2
    ];

    custom = with pkgsCustom; [
      pgsrip
      vocabsieve
      zen-browser
    ];
  };
in
{
  users.users.kuroko.packages = lib.pipe homePackages [
    (lib.mapAttrsToList (name: value: value))
    lib.flatten
  ];
}
