{
  lib,
  pkgs,
  ...
}:
let
  packages = with pkgs; {
    networking = [
      aria2
      wget
    ];

    nix = [
      nix-your-shell
    ];

    media = [
      mediainfo
      mkvtoolnix-cli
      opus-tools
      yt-dlp
    ];

    git = [
      gh
      git
      lazygit
      rs-git-fsmonitor
    ];

    security = [
      bubblewrap
      libsecret
      osslsigncode
    ];

    system = [
      dua
      eza
      fd
      libavif
      libheif
      libjxl
      ouch
      ripgrep
      tree
      unzip
      zip
    ];

    productivity = [
      cheat
    ];

    development = [
      addlicense
      difftastic
    ];

    tools = [
      duf # disk usage/free
      duperemove
      htop-vim
      innoextract
      jpegoptim
      lurk
      mat2
      optipng
      pciutils
      powerstat
      usbutils
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
