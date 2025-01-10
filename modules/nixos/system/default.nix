{
  pkgsCustom,
  pkgs,
  username,
  ...
}:
{
  imports = [
    ./programs.nix
  ];

  # Set fish as the default user shell for all users
  users.defaultUserShell = pkgsCustom.fish;
  programs.fish.enable = true;
  programs.fish.package = pkgsCustom.fish;

  documentation.nixos.enable = false;
  documentation.man.generateCaches = false; # slow eval time with fish

  time.timeZone = "CET";

  # Internationalisation properties
  i18n.defaultLocale = "de_DE.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "de_DE.UTF-8";
    LC_IDENTIFICATION = "de_DE.UTF-8";
    LC_MEASUREMENT = "de_DE.UTF-8";
    LC_MONETARY = "de_DE.UTF-8";
    LC_NAME = "de_DE.UTF-8";
    LC_NUMERIC = "de_DE.UTF-8";
    LC_PAPER = "de_DE.UTF-8";
    LC_TELEPHONE = "de_DE.UTF-8";
    LC_TIME = "de_DE.UTF-8";
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
    XDG_CACHE_HOME = "$HOME/.cache";
    XDG_CONFIG_HOME = "$HOME/.config";
    XDG_DATA_HOME = "$HOME/.local/share";
    XDG_STATE_HOME = "$HOME/.local/state";

    # Not officially in the specification
    XDG_BIN_HOME = "$HOME/.local/bin";
    PATH = [ "${XDG_BIN_HOME}" ];

    # for `programs.nh`
    FLAKE = "/home/${username}/nixos";
  };
}
