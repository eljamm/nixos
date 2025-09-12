{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config.programs.ccache;
in
{
  # Incremental Builds
  programs.ccache.enable = lib.mkDefault true;

  nixpkgs.overlays = lib.mkIf cfg.enable [
    (_: super: {
      ccacheWrapper = super.ccacheWrapper.override {
        extraConfig = ''
          export CCACHE_DIR="${cfg.cacheDir}"
          export CCACHE_UMASK=007
          export CCACHE_NOCOMPRESS=true
          export CCACHE_MAXSIZE=10G
          export CCACHE_SLOPPINESS=random_seed
          if [ ! -d "$CCACHE_DIR" ]; then
            echo "====="
            echo "Directory '$CCACHE_DIR' does not exist"
            echo "Please create it with:"
            echo "  sudo mkdir -m0770 '$CCACHE_DIR'"
            echo "  sudo chown ${cfg.owner}:${cfg.group} '$CCACHE_DIR'"
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

  nix.settings = lib.mkIf cfg.enable {
    extra-sandbox-paths = [ cfg.cacheDir ];
  };

  environment.systemPackages = [ pkgs.ccache ];
}
