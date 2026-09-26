{
  pkgsUnstable,
  username,
  lib,
  ...
}:
{
  imports = [
    ./binary-cache.nix
    ./hardware
    ./networking.nix
    ./packages.nix
    ./remote-builder
  ];

  users.users.${username} = {
    description = "${username}";
    extraGroups = [ "wheel" ];
    isNormalUser = true;
    uid = 1000;
    openssh.authorizedKeys.keyFiles = [
      ./keys/joker-kuroko.pub
    ];
  };

  # Disable unnecessary modules
  fonts.fontconfig.enable = lib.mkForce false;
  services.pipewire.enable = lib.mkForce false;
  services.speechd.enable = lib.mkForce false;
  programs.ccache.enable = lib.mkForce true;

  nix = {
    package = pkgsUnstable.nixVersions.latest;

    # Enable flakes
    extraOptions = ''
      experimental-features = nix-command flakes
    '';

    # Storage Optimization
    optimise.automatic = true;

    settings = {
      # Cache
      substituters = [ "https://nix-community.cachix.org" ];
      trusted-public-keys = [ "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs=" ];

      warn-dirty = false; # NOTE: I do not care.
    };
  };

  # WARN:
  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?
}
