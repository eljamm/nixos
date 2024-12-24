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
      nix-init
      nix-inspect
      nix-tree
      nix-your-shell
      nixpkgs-review
    ];

    media = [
      mediainfo
      mkvtoolnix-cli
      opusTools
      yt-dlp
    ];

    git = [
      gh
      git
      lazygit
      rs-git-fsmonitor
      tig
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
      termdown
    ];

    development = [
      addlicense
      devenv
      difftastic
      license-cli
    ];

    tools = [
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
    (lib.mapAttrsToList (name: value: value))
    lib.flatten
  ];
}
