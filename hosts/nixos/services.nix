{
  config,
  pkgs,
  ...
}:
{
  # Enable CUPS to print documents.
  services.printing.enable = false;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # TODO: move
  services.xserver.wacom.enable = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  programs.firejail.enable = true;

  programs.adb.enable = true;

  # https://github.com/viperML/nh
  programs.nh = {
    enable = true;
    flake = config.environment.sessionVariables.FLAKE;
  };

  # https://github.com/nix-community/nix-ld
  programs.nix-ld.enable = true;

  # https://github.com/mic92/envfs
  services.envfs.enable = true;

  # OpenSSH daemon
  services.openssh = {
    enable = false;
    # require public key authentication for better security
    settings.PasswordAuthentication = false;
    settings.KbdInteractiveAuthentication = false;
    settings.PermitRootLogin = "no";
  };

  # Reddit
  services.redlib.enable = true;

  services.calibre-server = {
    enable = false;
    port = 4242;
    user = "kuroko";
    group = "users";
    libraries = [
      "/home/kuroko/Calibre Library"
      "/home/kuroko/Calibre Light Novels"
    ];
  };

  virtualisation.docker = {
    enable = true;
    rootless = {
      enable = true;
      setSocketVariable = true;
    };
  };
}
