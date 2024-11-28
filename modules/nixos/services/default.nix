{ config, ... }:
{
  imports = [
    ./anki.nix
    ./blocky.nix
    ./keyd.nix
    ./misc.nix
    ./mumble.nix
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # https://github.com/viperML/nh
  programs.nh = {
    enable = true;
    flake = config.environment.sessionVariables.FLAKE;
  };
}
