{
  pkgsUnstable,
  username,
  ...
}:
{
  imports = [
    ./programs.nix
    ./fonts.nix
  ];

  # Set fish as the default user shell for all users
  users.defaultUserShell = pkgsUnstable.fish;
  programs.fish.enable = true;
  programs.fish.package = pkgsUnstable.fish;

  documentation.nixos.enable = false;
  documentation.man.generateCaches = false; # slow eval time with fish

  time.timeZone = "CET";

  # Internationalisation properties
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Configure keymap in X11
  services.xserver = {
    xkb = {
      layout = "de";
      variant = "nodeadkeys";
    };
  };

  # Configure console keymap
  console.keyMap = "de-latin1-nodeadkeys";

  environment.sessionVariables = rec {
    # for `programs.nh`
    FLAKE = "/home/${username}/nixos";

    XDG_CACHE_HOME = "$HOME/.cache";
    XDG_CONFIG_HOME = "$HOME/.config";
    XDG_DATA_HOME = "$HOME/.local/share";
    XDG_STATE_HOME = "$HOME/.local/state";

    # Not officially in the specification
    XDG_BIN_HOME = "$HOME/.local/bin";
    PATH = [ "${XDG_BIN_HOME}" ];

    AW_SYNC_DIR = "$XDG_DATA_HOME/ActivityWatchSync";
    DOCKER_CONFIG = "$XDG_CONFIG_HOME/docker"; # TODO: ~/.docker
    DVDCSS_CACHE = "$XDG_DATA_HOME/dvdcss";
    ELM_HOME = "$XDG_CONFIG_HOME/elm";
    MINETEST_USER_PATH = "$XDG_DATA_HOME/luanti";
    NPM_CONFIG_USERCONFIG = "$XDG_CONFIG_HOME/npm/npmrc"; # TODO: ~/.npm
    NUGET_PACKAGES = "$XDG_CACHE_HOME/NuGetPackages";
    OPAMROOT = "$XDG_DATA_HOME/opam";
    PARALLEL_HOME = "$XDG_CONFIG_HOME/parallel";

    XCOMPOSECACHE = "$XDG_CACHE_HOME/X11/xcompose";
    XCOMPOSEFILE = "$XDG_CONFIG_HOME/X11/xcompose"; # TODO: ~/.compose-cache

    # Ruby bundler
    BUNDLE_USER_CACHE = "$XDG_CACHE_HOME/bundle";
    BUNDLE_USER_CONFIG = "$XDG_CONFIG_HOME/bundle/config";
    BUNDLE_USER_PLUGIN = "$XDG_DATA_HOME/bundle";

    # Rust
    CARGO_HOME = "$XDG_DATA_HOME/cargo"; # TODO: ~/.cargo
    RUSTUP_HOME = "$XDG_DATA_HOME/rustup";

    # Haskell
    STACK_XDG = "1";
    GHCUP_USE_XDG_DIRS = "1";

    # Maven
    MAVEN_ARGS = "--settings $XDG_CONFIG_HOME/maven/settings.xml";
    MAVEN_OPTS = ''-Dmaven.repo.local="$XDG_DATA_HOME/maven/repository"'';

    GRADLE_USER_HOME = "$XDG_DATA_HOME/gradle";
    _JAVA_OPTIONS = ''-Djava.util.prefs.userRoot="$XDG_CONFIG_HOME/java"''; # TODO: ~/.java
  };
}
