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
      discord
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
      pkgsUnstable.famistudio
      tuxguitar

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

      # Tools
      dl-librescore
    ];

    gameDevelopment = [
      godot_4
      godot3
    ];

    games = [
      openmw
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
      pkgsCustom.pdfid
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
      grc
      piper-tts
      pkgsUnstable.pgsrip
    ];

    custom = with pkgsCustom; [
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
