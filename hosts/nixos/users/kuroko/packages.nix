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
      # pkgsUnstable.vaporizer2
      surge
      tunefish
      vcv-rack
      vital
      x42-avldrums
      yabridge
      yabridgectl
      aether-lv2

      # Tools
      dl-librescore
      abcm2ps
      abcmidi
      easyabc
      lrcget
    ];

    gameDevelopment = [
      godot3
      godot_4
      pkgsUnstable.arrow
    ];

    games = [
      openmw
    ];

    graphics = [
      aseprite
      gimp
      inkscape
      krita
      pixelorama
      rnote
      realesrgan-ncnn-vulkan
      waifu2x-converter-cpp
    ];

    education = [
      anki
      ki
    ];

    office = [
      crow-translate
      lifeograph
      pkgsCustom.pdfid
      zathura
    ];

    system = [
      albert
      speechd
      copyq
    ];

    development = [
      mold-wrapped
      sqlitebrowser
    ];

    utils = [
      grc
      piper-tts
    ];

    custom = with pkgsCustom; [
      vocabsieve
    ];
  };
in
{
  users.users.kuroko.packages = lib.pipe homePackages [
    lib.attrValues
    lib.flatten
  ];
}
