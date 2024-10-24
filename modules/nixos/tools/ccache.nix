{
  config,
  lib,
  ...
}:
let
  ccacheEnabled = config.programs.ccache.enable;
in
{
  # Incremental Builds
  programs.ccache.enable = lib.mkDefault true;

  nixpkgs.overlays = lib.mkIf ccacheEnabled [
    (_: super: {
      ccacheWrapper = super.ccacheWrapper.override {
        extraConfig = ''
          export CCACHE_DIR="${config.programs.ccache.cacheDir}"
          export CCACHE_UMASK=007
          export CCACHE_NOCOMPRESS=true
          export CCACHE_MAXSIZE=10G
          export CCACHE_SLOPPINESS=random_seed
          export CCACHE_BASEDIR="$NIX_BUILD_TOP"
          if [ ! -d "$CCACHE_DIR" ]; then
            echo "====="
            echo "Directory '$CCACHE_DIR' does not exist"
            echo "Please create it with:"
            echo "  sudo mkdir -m0770 '$CCACHE_DIR'"
            echo "  sudo chown root:nixbld '$CCACHE_DIR'"
            echo "====="
            exit 1
          fi
          if [ ! -w "$CCACHE_DIR" ]; then
            echo "====="
            echo "Directory '$CCACHE_DIR' is not accessible for user $(whoami)"
            echo "Please verify its access permissions"
            echo "====="
            exit 1
          fi
        '';
      };
    })
  ];

  nix.settings = lib.mkIf ccacheEnabled {
    extra-sandbox-paths = [ config.programs.ccache.cacheDir ];
  };
}
