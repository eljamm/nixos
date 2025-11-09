{
  lib,
  username,
  ...
}:
{
  imports = [
    ../../hardware/navi
    ../nixos/overlays
    ./networking.nix
    ./packages.nix
  ];

  users.users.${username} = {
    description = "${username}";
    extraGroups = [ "wheel" ];
    isNormalUser = true;
    uid = 1000;
  };

  # Disable unnecessary modules
  fonts.fontconfig.enable = lib.mkForce false;
  services.pipewire.enable = lib.mkForce false;
  services.speechd.enable = lib.mkForce false;
  programs.ccache.enable = lib.mkForce true;

  # WARN:
  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?
}
