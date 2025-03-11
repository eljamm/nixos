{ pkgs, ... }:
{
  imports = [
    ../../hardware/legion
    ../navi/docker.nix
    ./agenix.nix
    ./networking.nix
    ./overlays
    ./packages.nix
    ./services.nix
    ./users/kuroko
  ];

  # Enable the X11 windowing system
  services.xserver.enable = true;

  custom.desktops = {
    gnome.enable = true;
    hyprland.enable = true;
  };

  # Register AppImage files as a binary type
  boot.binfmt.registrations.appimage = {
    wrapInterpreterInShell = false;
    interpreter = "${pkgs.appimage-run}/bin/appimage-run";
    recognitionType = "magic";
    offset = 0;
    mask = ''\xff\xff\xff\xff\x00\x00\x00\x00\xff\xff\xff'';
    magicOrExtension = ''\x7fELF....AI\x02'';
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
