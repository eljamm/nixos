#
# TODO: install
# - neovim
# - yazi
#
{
  pkgs,
  ...
}:
{
  custom.systemPackages = with pkgs; {
    networking = [
      aria2
      wget
    ];

    nix = [
      nh
      nix-output-monitor
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
      difftastic
      mold
      sccache
      watchexec
    ];

    tools = {
      cleanup = [
        duf # disk usage/free
        duperemove
        mat2
      ];
      monitoring = [
        btop
        htop-vim
      ];
      debug = [
        lurk # prettier strace
      ];
      other = [
        pciutils
        usbutils
      ];
    };
  };
}
